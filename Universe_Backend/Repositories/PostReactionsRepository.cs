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
        await dbContext.Set<PostReaction>().AddAsync(reaction.ToModel());
        await dbContext.SaveChangesAsync();
        return reaction.Id;
    }

    public async Task RemoveReaction(int reactionId)
    {
        logger.LogDebug("PostReactionsRepository.RemoveReaction: Removing reaction from post.");
        var reaction = await dbContext.PostsReactions.FindAsync(reactionId);
        if (reaction == null)
        {
            // throw NotFoundException().
        }

        dbContext.PostsReactions.Remove(reaction!);
        await dbContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<PostReactionDTO>> GetReactions(int postId)
    {
        logger.LogDebug("PostReactionsRepository.GetReactions: Getting reactions for post.");
        var reactions = await dbContext.PostsReactions.Where(r => r.PostId == postId).ToListAsync();
        return reactions.Select(r => r.ToDTO());
    }

    public async Task<int> GetReactionsCount(int postId)
    {
        logger.LogDebug("PostReactionsRepository.GetReactionsCount: Getting reactions count for post.");
        int reactionsCount = await dbContext.PostsReactions.Where(r => r.PostId == postId).CountAsync();
        return reactionsCount;
    }
}