using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public interface IUsersRepository
{
    public Task<IEnumerable<UserDTO>> SearchUsers(string query, DateTime? lastDate, string? lastId);
    public Task<UserDTO> GetUser(string id);
    public Task AddFollower(string followerId, string followedId);
    public Task RemoveFollower(string followerId, string followedId);
    public Task<IEnumerable<UserDTO>> GetFollowers(string userId, DateTime? lastDate, string? lastId);
    public Task<IEnumerable<UserDTO>> GetFollowing(string userId, DateTime? lastDate, string? lastId);
    public Task UpdateUser(UserDTO user);
    public Task<int> GetFollowersCount(string userId);
    public Task<int> GetFollowingCount(string userId);
    public Task<IEnumerable<NotificationToken>> GetNotificationTokens(string userId);
    public Task<bool> IsUserNameAvailable(string userName);
    public Task<bool> IsUserOneFollowingUserTwo(string userOneId, string userTwoId);
}