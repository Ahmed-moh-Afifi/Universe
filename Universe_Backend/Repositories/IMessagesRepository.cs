
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories
{
    public interface IMessagesRepository
    {
        public Task<Message> AddMessageAsync(Message message);
        public Task<Message> GetMessageAsync(int messageId);
        public Task<List<Message>> GetChatMessagesAsync(int chatId);
        public Task<List<Message>> GetUserMessagesAsync(string userId);
        public Task<List<Message>> GetRepliesAsync(int messageId);
        public Task AddReactionAsync(MessageReaction reaction);
        public Task RemoveReactionAsync(int reactionId);
        //public Task AddMentionAsync(int messageId, string userId);
        //public Task RemoveMentionAsync(int messageId, string userId);
        public Task DeleteMessageAsync(int messageId);
    }
}
