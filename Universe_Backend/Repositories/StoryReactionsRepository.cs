using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public class StoryReactionsRepository(ApplicationDbContext dbContext, ILogger<StoryReactionsRepository> logger) : IStoryReactionsRepository
{
    public async Task<int> AddReaction(StoryReactionDTO reaction)
    {
        logger.LogDebug("StoryReactionsRepository.AddReaction: Adding reaction.");
        try
        {
            await dbContext.StoriesReactions.AddAsync(reaction.ToModel());
            await dbContext.SaveChangesAsync();
            return reaction.Id;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoryReactionsRepository.AddReaction: Error adding reaction.");
            throw;
        }
    }

    public async Task RemoveReaction(int reactionId)
    {
        logger.LogDebug("StoryReactionsRepository.RemoveReaction: Removing reaction.");
        try
        {
            var reaction = await dbContext.StoriesReactions.FindAsync(reactionId);
            if (reaction == null)
            {
                // throw NotFoundException().
            }

            dbContext.StoriesReactions.Remove(reaction!);
            await dbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoryReactionsRepository.RemoveReaction: Error removing reaction.");
            throw;
        }
    }

    public async Task<IEnumerable<StoryReactionDTO>> GetReactions(int StoryId, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("StoryReactionsRepository.GetReactions: Getting reactions.");
        try
        {
            List<StoryReactionDTO> reactions;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("StoryReactionsRepository.GetReactions: Getting first 10 reactions.");
                reactions = await dbContext.StoriesReactions
                    .Where(r => r.StoryId == StoryId)
                    .OrderBy(r => r.ReactionDate)
                    .ThenBy(r => r.Id)
                    .Select(r => r.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("StoryReactionsRepository.GetReactions: Getting reactions after date {LastDate} and id {LastId}.", lastDate, lastId);
                reactions = await dbContext.StoriesReactions
                    .Where(r => r.StoryId == StoryId)
                    .OrderBy(r => r.ReactionDate)
                    .ThenBy(r => r.Id)
                    .Where(r => r.ReactionDate > lastDate || (r.ReactionDate == lastDate && r.Id > lastId))
                    .Select(r => r.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }

            return reactions;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoryReactionsRepository.GetReactions: Error getting reactions.");
            throw;
        }
    }

    public async Task<int> GetReactionsCount(int StoryId)
    {
        logger.LogDebug("StoryReactionsRepository.GetReactionsCount: Getting reactions count.");
        try
        {
            int reactionsCount = await dbContext.StoriesReactions.Where(r => r.StoryId == StoryId).CountAsync();
            return reactionsCount;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoryReactionsRepository.GetReactionsCount: Error getting reactions count.");
            throw;
        }
    }
}
