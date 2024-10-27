﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using NotificationService.Models;
using System.Security.Claims;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Hubs
{
    [Authorize]
    public class MessagingHub(ILogger<MessagingHub> logger, ApplicationDbContext dbContext, NotificationService.NotificationService notificationService, IUsersRepository usersRepository) : Hub
    {
        public async Task SendToUserAsync(string userId, string messageBody)
        {
            string sender = Context.User!.FindFirstValue("uid")!;
            logger.LogDebug($"User {sender} sending to user {userId}");

            var message = new Message() { AuthorId = sender, Body = messageBody, Id = 0, ChatId = 0 };
            //await dbContext.Messages.AddAsync(message);
            //await dbContext.SaveChangesAsync();

            var onlineStatus = await dbContext.Users.Where(u => u.Id == userId).Select(u => u.OnlineStatus).FirstOrDefaultAsync();
            if (onlineStatus == OnlineStatus.Online)
            {
                await Clients.User(userId).SendAsync("MessageReceived", message);
            }
            else
            {
                var notificationTokens = await usersRepository.GetNotificationTokens(userId);
                if (!notificationTokens.IsNullOrEmpty())
                {
                    var notification = new MultipleUserNotification()
                    {
                        Recipients = notificationTokens.Select(nt => nt.Token).ToList(),
                        Sender = sender,
                        Title = "New message",
                        Body = messageBody,
                        Platform = Platform.Android
                    };

                    await notificationService.SendNotificationAsync(notification);
                }
            }
        }

        public async Task NotifyUserAsync(string userId, InAppNotification notification)
        {
            var user = await dbContext.Users.FindAsync(userId);
            if (user != null && user.OnlineStatus == OnlineStatus.Online)
            {
                await Clients.User(userId).SendAsync("NotificationReceived", notification);
            }
            else
            {
                await notificationService.SendNotificationAsync(new MultipleUserNotification()
                {
                    Recipients = (await usersRepository.GetNotificationTokens(userId)).Select(nt => nt.Token).ToList(),
                    Sender = notification.Sender,
                    Title = notification.Title,
                    Body = notification.Body,
                    Platform = Platform.Android
                });
            }
        }

        public async Task NotifyUsersAsync(List<string> userIds, InAppNotification notification)
        {
            var users = await dbContext.Users.Where(u => userIds.Contains(u.Id)).ToListAsync();
            var onlineUsers = users.Where(u => u.OnlineStatus == OnlineStatus.Online).ToList();
            var offlineUsers = users.Where(u => u.OnlineStatus == OnlineStatus.Offline).ToList();

            if (!onlineUsers.IsNullOrEmpty())
            {
                await Clients.Users(onlineUsers.Select(u => u.Id)).SendAsync("NotificationReceived", notification);
            }

            if (!offlineUsers.IsNullOrEmpty())
            {
                var ids = offlineUsers.Select(u => u.Id).ToList();
                var notificationTokens = await dbContext.NotificationTokens.Where(nt => ids.Contains(nt.UserId)).ToListAsync();

                if (!notificationTokens.IsNullOrEmpty())
                {
                    await notificationService.SendNotificationAsync(new MultipleUserNotification()
                    {
                        Recipients = notificationTokens.Select(nt => nt.Token).ToList(),
                        Sender = notification.Sender,
                        Title = notification.Title,
                        Body = notification.Body,
                        Platform = Platform.Android
                    });
                }
            }
        }

        public override async Task OnConnectedAsync()
        {
            string sender = Context.User!.FindFirstValue("uid")!;
            logger.LogDebug($"User {sender} connected");

            var user = await dbContext.Users.FindAsync(sender);
            if (user != null)
            {
                user.OnlineStatus = OnlineStatus.Online;
                await dbContext.SaveChangesAsync();
            }

            await base.OnConnectedAsync();
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            string sender = Context.User!.FindFirstValue("uid")!;
            logger.LogDebug($"User {sender} disconnected");

            var user = await dbContext.Users.FindAsync(sender);
            if (user != null)
            {
                user.LastOnline = DateTime.UtcNow;
                user.OnlineStatus = OnlineStatus.Offline;
                await dbContext.SaveChangesAsync();
            }

            await base.OnDisconnectedAsync(exception);
        }
    }
}
