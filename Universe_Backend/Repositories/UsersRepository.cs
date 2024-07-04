using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public class UsersRepository(ApplicationDbContext dbContext, UserManager<User> userManager, ILogger<UsersRepository> logger) : IUsersRepository
{
    public async Task<IEnumerable<UserDTO>> SearchUsers(string query)
    {
        logger.LogDebug("UsersRepository.SearchUsers: Searching for users with query: {query}", query);
        try
        {
            var users = await dbContext.Users.Where(user => user.UserName!.Contains(query) || user.FirstName.Contains(query) || user.LastName.Contains(query) || query.Contains(user.UserName) || query.Contains(user.FirstName) || query.Contains(user.LastName)).ToListAsync();
            return users.Select(u => u.ToDTO());
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.SearchUsers: Error while searching for users with query: {query}", query);
            throw;
        }
    }

    public async Task<UserDTO> GetUser(string id)
    {
        logger.LogDebug("UsersRepository.GetUser: Getting user with id: {id}", id);
        try
        {
            var user = await userManager.FindByIdAsync(id);
            if (user == null)
            {
                logger.LogWarning("UsersRepository.GetUser: User with id: {id} not found", id);
                // throw new NotFoundException("User not found");
            }
            return user!.ToDTO();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.GetUser: Error while getting user with id: {id}", id);
            throw;
        }
    }

    private async Task<User> GetUserRaw(string id)
    {
        logger.LogDebug("UsersRepository.GetUser: Getting user with id: {id}", id);
        try
        {
            var user = await userManager.FindByIdAsync(id);
            if (user == null)
            {
                logger.LogWarning("UsersRepository.GetUser: User with id: {id} not found", id);
                // throw new NotFoundException("User not found");
            }
            return user!;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.GetUser: Error while getting user with id: {id}", id);
            throw;
        }
    }

    public async Task AddFollower(string followerId, string followedId)
    {
        logger.LogDebug("UsersRepository.AddFollower: Adding follower with id: {followerId} to user with id: {followedId}", followerId, followedId);
        try
        {
            var follower = await GetUserRaw(followerId);
            var followed = await GetUserRaw(followedId);
            follower.Following.Add(followed);
            await dbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.AddFollower: Error while adding follower with id: {followerId} to user with id: {followedId}", followerId, followedId);
            throw;
        }
    }

    public async Task RemoveFollower(string followerId, string followedId)
    {
        logger.LogDebug("UsersRepository.RemoveFollower: Removing follower with id: {followerId} from user with id: {followedId}", followerId, followedId);
        try
        {
            var followed = await dbContext.Users.Include(u => u.Followers.Where(u => u.Id == followerId)).SingleAsync(u => u.Id == followedId);
            var res = followed.Followers.Remove(followed.Followers.Single(u => u.Id == followerId));
            await dbContext.SaveChangesAsync();
            logger.LogDebug("UsersRepository.RemoveFollower: Removed follower with id: {followerId} from user with id: {followedId} with result {res}", followerId, followedId, res);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.RemoveFollower: Error while removing follower with id: {followerId} from user with id: {followedId}", followerId, followedId);
            throw;
        }
    }

    public async Task<IEnumerable<UserDTO>> GetFollowers(string userId)
    {
        logger.LogDebug("UsersRepository.GetFollowers: Getting followers of user with id: {userId}", userId);
        try
        {
            var user = await dbContext.Users.Where(u => u.Id == userId).
            Select(u => new
            {
                Followers = u.Followers.Select(f => f.ToDTO())
            }).SingleAsync();

            logger.LogDebug("UsersRepository.GetFollowers: Found followers of user with id: {userId}", userId);
            return user.Followers.ToList();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.GetFollowers: Error while getting followers of user with id: {userId}", userId);
            throw;
        }
    }

    public async Task<IEnumerable<UserDTO>> GetFollowing(string userId)
    {
        logger.LogDebug("UsersRepository.GetFollowing: Getting following of user with id: {userId}", userId);

        try
        {
            var user = await dbContext.Users.Where(u => u.Id == userId).
            Select(u => new
            {
                Following = u.Following.Select(f => f.ToDTO())
            }).SingleAsync();

            logger.LogDebug("UsersRepository.GetFollowing: Found following of user with id: {userId}", userId);
            return user.Following.ToList();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.GetFollowing: Error while getting following of user with id: {userId}", userId);
            throw;
        }
    }

    public async Task UpdateUser(UserDTO user)
    {
        logger.LogDebug("UsersRepository.UpdateUser: Updating user with id: {id}", user.Id);
        try
        {
            dbContext.Users.Update(user.ToModel());
            await dbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.UpdateUser: Error while updating user with id: {id}", user.Id);
            throw;
        }
    }

    public async Task<int> GetFollowersCount(string userId)
    {
        logger.LogDebug("UsersRepository.GetFollowersCount: Getting followers count of user with id: {userId}", userId);
        try
        {
            var count = await dbContext.Users.Where(u => u.Id == userId).Select(u => u.Followers.Count).SingleAsync();
            return count;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.GetFollowersCount: Error while getting followers count of user with id: {userId}", userId);
            throw;
        }
    }

    public async Task<int> GetFollowingCount(string userId)
    {
        logger.LogDebug("UsersRepository.GetFollowingCount: Getting following count of user with id: {userId}", userId);
        try
        {
            var count = await dbContext.Users.Where(u => u.Id == userId).Select(u => u.Following.Count).SingleAsync();
            return count;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.GetFollowingCount: Error while getting following count of user with id: {userId}", userId);
            throw;
        }
    }
}