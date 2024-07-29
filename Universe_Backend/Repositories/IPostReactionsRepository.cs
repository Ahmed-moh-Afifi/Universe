using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public interface IPostReactionsRepository
{
    public Task<int> AddReaction(PostReactionDTO reaction);
    public Task RemoveReaction(int reactionId);
    public Task<IEnumerable<PostReactionDTO>> GetReactions(int postId, DateTime? lastDate, int? lastId);
    public Task<int> GetReactionsCount(int postId);
    public Task<PostReactionDTO?> IsPostReactedToByUser(int postId, string userId);
}