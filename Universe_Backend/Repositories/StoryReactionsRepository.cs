using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public class StoryReactionsRepository(ApplicationDbContext dbContext, ILogger<StoryReactionsRepository> logger) : IStoryReactionsRepository
{
    public async Task<int> AddReaction(StoryReaction reaction)
    {
        logger.LogDebug("StoryReactionsRepository.AddReaction: Adding reaction.");
        dbContext.StoriesReactions.Add(reaction);
        await dbContext.SaveChangesAsync();
        return reaction.Id;
    }

    public async Task RemoveReaction(int reactionId)
    {
        logger.LogDebug("StoryReactionsRepository.RemoveReaction: Removing reaction.");
        var reaction = await dbContext.StoriesReactions.FindAsync(reactionId);
        if (reaction == null)
        {
            // throw NotFoundException().
        }

        dbContext.StoriesReactions.Remove(reaction!);
        await dbContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<StoryReaction>> GetReactions(int StoryId)
    {
        logger.LogDebug("StoryReactionsRepository.GetReactions: Getting reactions.");
        return await dbContext.StoriesReactions.Where(r => r.StoryId == StoryId).ToListAsync();
    }

    public async Task<int> GetReactionsCount(int StoryId)
    {
        logger.LogDebug("StoryReactionsRepository.GetReactionsCount: Getting reactions count.");
        return await dbContext.StoriesReactions.Where(r => r.StoryId == StoryId).CountAsync();
    }
}
