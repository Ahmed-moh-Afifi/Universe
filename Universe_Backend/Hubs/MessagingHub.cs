using Microsoft.AspNetCore.Authorization;
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

            var message = new Message() {AuthorId = sender, Body = messageBody, Id = 0, ChatId = 0 };
            //await dbContext.Messages.AddAsync(message);
            //await dbContext.SaveChangesAsync();

            var notificationTokens = await usersRepository.GetNotificationTokens(userId);
            if (!notificationTokens.IsNullOrEmpty())
            {
                // Send push notification
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

            await Clients.User(userId).SendAsync("MessageReceived", message);
            await Clients.User(sender).SendAsync("MessageSent");
        }
    }
}
