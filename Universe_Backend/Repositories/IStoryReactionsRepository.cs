using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public interface IStoryReactionsRepository
{
    public Task<int> AddReaction(StoryReactionDTO reaction);
    public Task RemoveReaction(int reactionId);
    public Task<IEnumerable<StoryReactionDTO>> GetReactions(int StoryId, DateTime? lastDate, int? lastId);
    public Task<int> GetReactionsCount(int StoryId);
}
