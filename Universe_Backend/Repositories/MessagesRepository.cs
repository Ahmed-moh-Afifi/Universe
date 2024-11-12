using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories
{
    public class MessagesRepository(ApplicationDbContext dbContext, ILogger<MessagesRepository> logger) : IMessagesRepository
    {
        public async Task<Message> AddMessageAsync(Message message)
        {
            await dbContext.Messages.AddAsync(message);
            await dbContext.SaveChangesAsync();
            return message;
        }

        public async Task<Message> GetMessageAsync(int messageId)
        {
            return await dbContext.Messages.FindAsync(messageId) ?? throw new ArgumentException("Message not found.");
        }

        public async Task<List<Message>> GetChatMessagesAsync(int chatId)
        {
            return await dbContext.Messages
                .Where(message => message.ChatId == chatId)
                .ToListAsync();
        }

        public async Task<List<Message>> GetUserMessagesAsync(string userId)
        {
            return await dbContext.Messages
                .Where(message => message.AuthorId == userId)
                .ToListAsync();
        }

        public async Task<List<Message>> GetRepliesAsync(int messageId)
        {
            return await dbContext.Messages
                .Where(message => message.MessageRepliedTo == messageId)
                .ToListAsync();
        }

        public async Task AddReactionAsync(MessageReaction reaction)
        {
            reaction.Id = 0;
            dbContext.MessagesReactions.Add(reaction);
            await dbContext.SaveChangesAsync();
        }

        public async Task RemoveReactionAsync(int reactionId)
        {
            var reaction = await dbContext.MessagesReactions.FindAsync(reactionId);

            if (reaction == null)
            {
                throw new ArgumentException("Reaction not found");
            }

            dbContext.MessagesReactions.Remove(reaction);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteMessageAsync(int messageId)
        {
            var message = await GetMessageAsync(messageId);

            if (message == null)
            {
                throw new ArgumentException("Message not found");
            }

            dbContext.Messages.Remove(message);
            await dbContext.SaveChangesAsync();
        }
    }
}
