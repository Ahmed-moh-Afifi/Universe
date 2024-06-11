using Microsoft.EntityFrameworkCore;
using UniverseBackend.Data;

namespace UniverseBackend.Repositories;

class ReactionsRepository(ApplicationDbContext dbContext, Logger<ReactionsRepository> logger) : IReactionsRepository
{
    public async Task<int> AddReaction(Reaction reaction)
    {
        await dbContext.Set<Reaction>().AddAsync(reaction);
        await dbContext.SaveChangesAsync();
        return reaction.ID;
    }

    public async Task RemoveReaction(int reactionId)
    {
        var reaction = await dbContext.Set<Reaction>().FindAsync(reactionId);
        if (reaction == null)
        {
            // throw NotFoundException().
        }

        dbContext.Set<Reaction>().Remove(reaction!);
        await dbContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<Reaction>> GetReactions(int postId)
    {
        var reactions = await dbContext.Set<Reaction>().Where(r => r.PostID == postId).ToListAsync();
        return reactions;
    }

    public async Task<int> GetReactionsCount(int postId)
    {
        int reactionsCount = await dbContext.Set<Reaction>().Where(r => r.PostID == postId).CountAsync();
        return reactionsCount;
    }
}