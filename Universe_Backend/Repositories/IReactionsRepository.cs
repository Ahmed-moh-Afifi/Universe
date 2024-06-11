using UniverseBackend.Data;

namespace UniverseBackend.Repositories;

public interface IReactionsRepository
{
    public Task<int> AddReaction(Reaction reaction);
    public Task RemoveReaction(int reactionId);
    public Task<IEnumerable<Reaction>> GetReactions(int postId);
    public Task<int> GetReactionsCount(int postId);
}