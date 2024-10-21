using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using NotificationService.Models;
using System.Security.Claims;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Hubs
{
    [Authorize]
    public class MessagingHub(ILogger<MessagingHub> logger, ApplicationDbContext dbContext, NotificationService.NotificationService notificationService) : Hub
    {
        public async Task SendToUserAsync(string userId, string messageBody)
        {
            string sender = Context.User!.FindFirstValue("uid")!;
            logger.LogDebug($"User {sender} sending to user {userId}");

            var message = new Message() {AuthorId = sender, Body = messageBody, Id = 0, ChatId = 0 };
            //await dbContext.Messages.AddAsync(message);
            //await dbContext.SaveChangesAsync();

            var notificationToken = await dbContext.NotificationTokens.FirstOrDefaultAsync(nt => nt.UserId == userId);
            if (notificationToken != null)
            {
                // Send push notification
                SingleUserNotification notification = new()
                {
                    Title = "New message",
                    Body = messageBody,
                    Sender = sender,
                    Platform = Platform.Android,
                    RecipientType = RecipientType.User,
                    Recipient = notificationToken.Token,
                };

                await notificationService.SendNotificationAsync(notification);
            }

            await Clients.User(userId).SendAsync("MessageReceived", message);
            await Clients.User(sender).SendAsync("MessageSent");
        }
    }
}
