using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories
{
    public interface IChatsRepository
    {
        public Task<Chat> CreateChatAsync(string name, IEnumerable<string> userIds);
        public Task<List<ChatDTO>> GetUserChatsAsync(string userId);
        public Task<ChatDTO> GetChatAsync(string callerId, int chatId);
        public Task<ChatDTO> GetChatForOtherAsync(string callerId, int chatId);
        public Task AddUserToChatAsync(int chatId, string userId);
        public Task RemoveUserFromChatAsync(int chatId, string userId);
        public Task DeleteChatAsync(int chatId);
        public Task<ChatDTO> GetChatByParticipantsAsync(string conversationInitiatorId, string targetedGuyId);
    }
}
