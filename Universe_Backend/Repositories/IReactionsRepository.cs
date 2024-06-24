using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public interface IReactionsRepository
{
    public Task<int> AddReaction(PostReaction reaction);
    public Task RemoveReaction(int reactionId);
    public Task<IEnumerable<PostReaction>> GetReactions(int postId);
    public Task<int> GetReactionsCount(int postId);
}