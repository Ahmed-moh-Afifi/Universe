using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using NotificationService.Models;
using System.Runtime.CompilerServices;
using System.Security.Claims;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Hubs
{
    [Authorize]
    public class MessagingHub(ILogger<MessagingHub> logger, ApplicationDbContext dbContext, NotificationService.NotificationService notificationService, IUsersRepository usersRepository, IChatsRepository chatsRepository) : Hub
    {
        public async Task SendToUserAsync(string userId, Message message)
        {
            string sender = Context.User!.FindFirstValue("uid")!;
            logger.LogDebug($"User {sender} sending to user {userId}");

            message.Id = 0;
            await dbContext.Messages.AddAsync(message);
            var chat = await chatsRepository.GetChatAsync(userId, message.ChatId);
            await dbContext.SaveChangesAsync();

            if (sender != userId)
            {
                var onlineSessions = await dbContext.Users.Where(u => u.Id == userId).Select(u => u.OnlineSessions).FirstOrDefaultAsync();
                if (onlineSessions > 0)
                {
                    logger.LogDebug("Sending signalr...");
                    await Clients.User(userId).SendAsync("MessageReceived", message.ToDTO());
                }
                else
                {
                    logger.LogDebug("Sending firebase...");
                    var notificationTokens = await usersRepository.GetNotificationTokens(userId);
                    if (!notificationTokens.IsNullOrEmpty())
                    {
                        var notification = new MultipleUserNotification()
                        {
                            Recipients = notificationTokens.Select(nt => nt.Token).ToList(),
                            Sender = sender,
                            Title = $"{chat?.Name}",
                            Body = message.Body,
                            Platform = Platform.Android,
                        };

                        await notificationService.SendNotificationAsync(notification);
                    }
                }
            }
        }

        public async Task SendUserStatus(UserStatus status)
        {
            await Clients.Group(Context.User!.FindFirstValue("uid")!).SendAsync("UpdateUserStatus", Context.User!.FindFirstValue("uid")!, status);
        }

        public async Task SubscribeToUsersStatus(List<string> userIds)
        {
            logger.LogDebug($"Subscribing to users: {userIds.Count}");
            foreach (string uid in userIds)
            {
                await Groups.AddToGroupAsync(Context.ConnectionId, uid);
            }
        }

        public async Task UnsubscribeFromUsersStatus(List<string> userIds)
        {
            foreach (string uid in userIds)
            {
                await Groups.RemoveFromGroupAsync(Context.ConnectionId, uid);
            }
        }

        public async Task NotifyUserAsync(string userId, InAppNotification notification)
        {
            var user = await dbContext.Users.FindAsync(userId);
            if (user != null && user.OnlineSessions > 0)
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
                    Platform = Platform.Android,
                });
            }
        }

        public async Task NotifyUsersAsync(List<string> userIds, InAppNotification notification)
        {
            var users = await dbContext.Users.Where(u => userIds.Contains(u.Id)).ToListAsync();
            var onlineUsers = users.Where(u => u.OnlineSessions > 0).ToList();
            var offlineUsers = users.Where(u => u.OnlineSessions > 0).ToList();

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
                        Platform = Platform.Android,
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
                user.OnlineSessions++;
                await dbContext.SaveChangesAsync();
                await Clients.Group(sender).SendAsync("UpdateUserStatus", sender, new UserStatus() { Status = "Online", LastOnline = DateTime.Now });
            }
            else
            {
                logger.LogDebug("**************************************** User = Null");
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
                user.OnlineSessions = user.OnlineSessions > 0 ? user.OnlineSessions - 1 : 0;
                await dbContext.SaveChangesAsync();
                if (user.OnlineSessions == 0)
                {
                    await Clients.Group(sender).SendAsync("UpdateUserStatus", sender, new UserStatus() { Status = "Offline", LastOnline = DateTime.Now });
                }
            }

            await base.OnDisconnectedAsync(exception);
        }
    }
}
