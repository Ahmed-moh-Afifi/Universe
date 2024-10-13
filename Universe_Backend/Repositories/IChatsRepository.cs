using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories
{
    public interface IChatsRepository
    {
        public Task<Chat> CreateChatAsync(string name, IEnumerable<string> userIds);
        public Task<List<Chat>> GetUserChatsAsync(string userId);
        public Task<Chat> GetChatAsync(int chatId);
        public Task AddUserToChatAsync(int chatId, string userId);
        public Task RemoveUserFromChatAsync(int chatId, string userId);
        public Task DeleteChatAsync(int chatId);
        public Task<Chat> GetChatByParticipantsAsync(string conversationInitiatorId, string targetedGuyId);
    }
}
