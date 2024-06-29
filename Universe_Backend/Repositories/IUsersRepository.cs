using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public interface IUsersRepository
{
    public Task<List<User>> SearchUsers(string query);
    public Task<User> GetUser(string id);
    public Task AddFollower(string followerId, string followedId);
    public Task RemoveFollower(string followerId, string followedId);
    public Task<List<UserDTO>> GetFollowers(string userId);
    public Task<List<UserDTO>> GetFollowing(string userId);
    public Task UpdateUser(User user);
    public Task<int> GetFollowersCount(string userId);
    public Task<int> GetFollowingCount(string userId);
}