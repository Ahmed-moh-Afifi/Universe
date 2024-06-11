using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client;
using UniverseBackend.Data;

namespace UniverseBackend.Repositories;

public class UsersRepository(ApplicationDbContext dbContext, ILogger<UsersRepository> logger) : IUsersRepository
{
    public async Task<int> CreateUser(User user)
    {
        user.ID = 0;
        await dbContext.Set<User>().AddAsync(user);
        await dbContext.SaveChangesAsync();
        return user.ID;
    }

    public async Task<List<User>> SearchUsers(string query)
    {
        var users = await dbContext.Set<User>().Where(user => user.UserName.Contains(query) || user.FirstName.Contains(query) || user.LastName.Contains(query)).ToListAsync();
        return users;
    }

    public async Task<User?> GetUser(int id)
    {
        var user = await dbContext.Set<User>().Where(user => user.ID == id).ElementAtAsync(0);
        return user;
    }

    public async Task AddFollower(int followerId, int followedId)
    {
        Follower follower = new()
        {
            FollowDate = DateTime.Now,
            FollowerId = followerId,
            FollowedId = followedId,
        };
        await dbContext.Set<Follower>().AddAsync(follower);
        await dbContext.SaveChangesAsync();
    }

    public async Task RemoveFollower(int followerId, int followedId)
    {
        Follower? follower = await dbContext.Set<Follower>().FindAsync(followerId, followedId);
        if (follower == null)
        {
            // throw not found exception.
        }
        dbContext.Set<Follower>().Remove(follower!);
        await dbContext.SaveChangesAsync();
    }

    public async Task<List<User>> GetFollowers(int userId)
    {
        var result =
        from follower in dbContext.Set<Follower>().Where(f => f.FollowedId == userId)
        join user in dbContext.Set<User>() on follower.FollowerId equals user.ID
        select user;

        var followers = await result.ToListAsync();

        return followers;
    }

    public async Task<List<User>> GetFollowing(int userId)
    {
        var result =
        from follower in dbContext.Set<Follower>().Where(f => f.FollowerId == userId)
        join user in dbContext.Set<User>() on follower.FollowedId equals user.ID
        select user;

        var following = await result.ToListAsync();

        return following;
    }
}