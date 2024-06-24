using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

class ReactionsRepository(ApplicationDbContext dbContext, Logger<ReactionsRepository> logger) : IReactionsRepository
{
    public async Task<int> AddReaction(PostReaction reaction)
    {
        await dbContext.Set<PostReaction>().AddAsync(reaction);
        await dbContext.SaveChangesAsync();
        return reaction.Id;
    }

    public async Task RemoveReaction(int reactionId)
    {
        var reaction = await dbContext.Set<PostReaction>().FindAsync(reactionId);
        if (reaction == null)
        {
            // throw NotFoundException().
        }

        dbContext.PostsReactions.Remove(reaction!);
        await dbContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<PostReaction>> GetReactions(int postId)
    {
        var reactions = await dbContext.PostsReactions.Where(r => r.PostId == postId).ToListAsync();
        return reactions;
    }

    public async Task<int> GetReactionsCount(int postId)
    {
        int reactionsCount = await dbContext.PostsReactions.Where(r => r.PostId == postId).CountAsync();
        return reactionsCount;
    }
}