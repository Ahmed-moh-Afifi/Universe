using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using System.Security.Claims;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Hubs
{
    [Authorize]
    public class MessagingHub(ILogger<MessagingHub> logger, ApplicationDbContext dbContext) : Hub
    {
        public async Task SendToUserAsync(string userId, string messageBody)
        {
            string sender = Context.User!.FindFirstValue("uid")!;
            logger.LogDebug($"User {sender} sending to user {userId}");

            //var message = new Message() {AuthorId = sender, Body = messageBody, Id = 0 };
            //await dbContext.Messages.AddAsync(message);
            //await dbContext.SaveChangesAsync();

            await Clients.User(userId).SendAsync("MessageReceived");
            await Clients.User(sender).SendAsync("MessageSent");
        }
    }
}
