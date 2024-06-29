using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public interface IStoryReactionsRepository
{
    public Task<int> AddReaction(StoryReaction reaction);
    public Task RemoveReaction(int reactionId);
    public Task<IEnumerable<StoryReaction>> GetReactions(int StoryId);
    public Task<int> GetReactionsCount(int StoryId);
}
