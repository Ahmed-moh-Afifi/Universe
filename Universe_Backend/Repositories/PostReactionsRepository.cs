using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

class PostReactionsRepository(ApplicationDbContext dbContext, ILogger<PostReactionsRepository> logger) : IPostReactionsRepository
{
    public async Task<int> AddReaction(PostReactionDTO reaction)
    {
        logger.LogDebug("PostReactionsRepository.AddReaction: Adding reaction to post.");
        try
        {
            await dbContext.PostsReactions.AddAsync(reaction.ToModel());
            await dbContext.SaveChangesAsync();
            return reaction.Id;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostReactionsRepository.AddReaction: Error adding reaction to post.");
            throw;
        }
    }

    public async Task RemoveReaction(int reactionId)
    {
        logger.LogDebug("PostReactionsRepository.RemoveReaction: Removing reaction from post.");
        try
        {
            var reaction = await dbContext.PostsReactions.FindAsync(reactionId);
            if (reaction == null)
            {
                // throw NotFoundException().
            }

            dbContext.PostsReactions.Remove(reaction!);
            await dbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostReactionsRepository.RemoveReaction: Error removing reaction from post.");
            throw;
        }
    }

    public async Task<IEnumerable<PostReactionDTO>> GetReactions(int postId, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("PostReactionsRepository.GetReactions: Getting reactions for post.");
        try
        {
            List<PostReactionDTO> reactions;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("PostReactionsRepository.GetReactions: Getting first 10 reactions for post.");
                reactions = await dbContext.PostsReactions
                    .Where(r => r.PostId == postId)
                    .OrderBy(r => r.ReactionDate)
                    .ThenBy(r => r.Id)
                    .Select(r => r.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("PostReactionsRepository.GetReactions: Getting reactions after date {LastDate} and id {LastId} for post.", lastDate, lastId);
                reactions = await dbContext.PostsReactions
                    .Where(r => r.PostId == postId)
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
            logger.LogError(ex, "PostReactionsRepository.GetReactions: Error getting reactions for post.");
            throw;
        }
    }

    public async Task<int> GetReactionsCount(int postId)
    {
        logger.LogDebug("PostReactionsRepository.GetReactionsCount: Getting reactions count for post.");
        try
        {
            return await dbContext.PostsReactions
                .Where(r => r.PostId == postId)
                .CountAsync();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostReactionsRepository.GetReactionsCount: Error getting reactions count for post.");
            throw;
        }

    }
}