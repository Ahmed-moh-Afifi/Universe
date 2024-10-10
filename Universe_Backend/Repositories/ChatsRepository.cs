using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories
{
    public class ChatsRepository(ApplicationDbContext dbContext, ILogger<ChatsRepository> logger) : IChatsRepository
    {
        public async Task<Chat> CreateChatAsync(string name, IEnumerable<string> userIds)
        {
            var chat = new Chat() { Name = name };
            await dbContext.Chats.AddAsync(chat);
            await dbContext.SaveChangesAsync();

            foreach (var userId in userIds)
            {
                await AddUserToChatAsync(chat.Id, userId);
            }

            return chat;
        }

        public async Task<List<Chat>> GetUserChatsAsync(string userId)
        {
            return await dbContext.Chats
                .Where(chat => chat.Users.Any(user => user.Id == userId))
                .ToListAsync();
        }

        public async Task<Chat> GetChatAsync(int chatId)
        {
            return await dbContext.Chats
                .Include(chat => chat.Users)
                .Include(chat => chat.Messages)
                .FirstOrDefaultAsync(chat => chat.Id == chatId) ?? throw new ArgumentException("Chat not found.");
        }

        public async Task AddUserToChatAsync(int chatId, string userId)
        {
            var chat = await GetChatAsync(chatId);
            var user = await dbContext.Users.FindAsync(userId);

            if (chat == null || user == null)
            {
                throw new ArgumentException("Chat or user not found");
            }

            chat.Users.Add(user);
            await dbContext.SaveChangesAsync();
        }

        public async Task RemoveUserFromChatAsync(int chatId, string userId)
        {
            var chat = await GetChatAsync(chatId);
            var user = await dbContext.Users.FindAsync(userId);

            if (chat == null || user == null)
            {
                throw new ArgumentException("Chat or user not found");
            }

            chat.Users.Remove(user);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteChatAsync(int chatId)
        {
            var chat = await GetChatAsync(chatId);

            if (chat == null)
            {
                throw new ArgumentException("Chat not found");
            }

            dbContext.Chats.Remove(chat);
            await dbContext.SaveChangesAsync();
        }
    }
}
