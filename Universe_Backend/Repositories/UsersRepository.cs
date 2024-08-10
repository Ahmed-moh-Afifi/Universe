using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public class UsersRepository(ApplicationDbContext dbContext, UserManager<User> userManager, ILogger<UsersRepository> logger) : IUsersRepository
{
    public async Task<IEnumerable<UserDTO>> SearchUsers(string query, DateTime? lastDate, string? lastId)
    {
        logger.LogDebug("UsersRepository.SearchUsers: Searching for users with query: {query}", query);
        try
        {
            List<UserDTO> users;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("UsersRepository.SearchUsers: Getting first 10 users with query: {query}", query);
                users = await dbContext.Users
                    .Where(user =>
                        user.UserName!.Contains(query) ||
                        user.FirstName.Contains(query) ||
                        user.LastName.Contains(query) ||
                        query.Contains(user.UserName) ||
                        query.Contains(user.FirstName) ||
                        query.Contains(user.LastName))
                    .OrderBy(u => u.JoinDate)
                    .ThenBy(u => u.Id)
                    .Select(u => u.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("UsersRepository.SearchUsers: Getting users with query: {query} after date {lastDate} and id {lastId}", query, lastDate, lastId);
                users = await dbContext.Users
                    .Where(user =>
                        user.UserName!.Contains(query) ||
                        user.FirstName.Contains(query) ||
                        user.LastName.Contains(query) ||
                        query.Contains(user.UserName) ||
                        query.Contains(user.FirstName) ||
                        query.Contains(user.LastName))
                    .OrderBy(u => u.JoinDate)
                    .ThenBy(u => u.Id)
                    .Where(u => u.JoinDate > lastDate || (u.JoinDate == lastDate && u.Id.CompareTo(lastId) > 0))
                    .Select(u => u.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }

            return users;
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

    public async Task<IEnumerable<UserDTO>> GetFollowers(string userId, DateTime? lastDate, string? lastId)
    {
        logger.LogDebug("UsersRepository.GetFollowers: Getting followers of user with id: {userId}", userId);
        try
        {
            List<UserDTO> followers;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("UsersRepository.GetFollowers: Getting first 10 followers of user with id: {userId}", userId);
                followers = await dbContext.Users
                    .Where(u => u.Following.Any(f => f.Id == userId))
                    .OrderBy(u => u.JoinDate)
                    .ThenBy(u => u.Id)
                    .Select(u => u.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("UsersRepository.GetFollowers: Getting followers of user with id: {userId} after date {lastDate} and id {lastId}", userId, lastDate, lastId);
                followers = await dbContext.Users
                    .Where(u => u.Following.Any(f => f.Id == userId))
                    .OrderBy(u => u.JoinDate)
                    .ThenBy(u => u.Id)
                    .Where(u => u.JoinDate > lastDate || (u.JoinDate == lastDate && u.Id.CompareTo(lastId) > 0))
                    .Select(u => u.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }

            return followers;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.GetFollowers: Error while getting followers of user with id: {userId}", userId);
            throw;
        }
    }

    public async Task<IEnumerable<UserDTO>> GetFollowing(string userId, DateTime? lastDate, string? lastId)
    {
        logger.LogDebug("UsersRepository.GetFollowing: Getting following of user with id: {userId}", userId);
        try
        {
            List<UserDTO> following;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("UsersRepository.GetFollowing: Getting first 10 following of user with id: {userId}", userId);
                following = await dbContext.Users
                    .Where(u => u.Followers.Any(f => f.Id == userId))
                    .OrderBy(u => u.JoinDate)
                    .ThenBy(u => u.Id)
                    .Select(u => u.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("UsersRepository.GetFollowing: Getting following of user with id: {userId} after date {lastDate} and id {lastId}", userId, lastDate, lastId);
                following = await dbContext.Users
                    .Where(u => u.Followers.Any(f => f.Id == userId))
                    .OrderBy(u => u.JoinDate)
                    .ThenBy(u => u.Id)
                    .Where(u => u.JoinDate > lastDate || (u.JoinDate == lastDate && u.Id.CompareTo(lastId) > 0))
                    .Select(u => u.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }

            return following;
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
            var userModel = dbContext.Users.Find(user.Id);
            userModel?.UpdateFromDTO(user);
            if (userModel != null)
            {
                dbContext.Users.Update(userModel);
                await dbContext.SaveChangesAsync();
            }
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

    public async Task<IEnumerable<NotificationToken>> GetNotificationTokens(string userId)
    {
        logger.LogDebug("UsersRepository.GetNotificationTokens: Getting notification tokens of user with id: {userId}", userId);
        try
        {
            var tokens = await dbContext.Users.Where(u => u.Id == userId).SelectMany(u => u.NotificationTokens).ToListAsync();
            logger.LogDebug("UsersRepository.GetNotificationTokens: Got notification tokens: {@tokens}", tokens.Count);
            return tokens;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.GetNotificationTokens: Error while getting notification tokens of user with id: {userId}", userId);
            throw;
        }
    }

    public async Task<bool> IsUserNameAvailable(string userName)
    {
        logger.LogDebug("UsersRepository.IsUserNameAvailable: Checking if username {userName} is available", userName);
        try
        {
            var user = await userManager.FindByNameAsync(userName);
            return user == null;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.IsUserNameAvailable: Error while checking if username {userName} is available", userName);
            throw;
        }
    }

    public async Task<bool> IsUserOneFollowingUserTwo(string userOneId, string userTwoId)
    {
        logger.LogDebug("UsersRepository.IsUserOneFollowingUserTwo: Checking if user with id {userOneId} is following user with id {userTwoId}", userOneId, userTwoId);
        try
        {
            var userTwo = await GetUserRaw(userTwoId);
            var found = dbContext.Users.Where(u => u.Id == userOneId).SelectMany(u => u.Following).Contains(userTwo);
            return found;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "UsersRepository.IsUserOneFollowingUserTwo: Error while checking if user with id {userOneId} is following user with id {userTwoId}", userOneId, userTwoId);
            throw;
        }
    }
}