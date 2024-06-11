using UniverseBackend.Data;

namespace UniverseBackend.Repositories;

public interface IUsersRepository
{
    public Task<int> CreateUser(User user);
    public Task<List<User>> SearchUsers(string query);
    public Task<User?> GetUser(int id);
    public Task AddFollower(int followerId, int followedId);
    public Task RemoveFollower(int followerId, int followedId);
    public Task<List<User>> GetFollowers(int userId);
    public Task<List<User>> GetFollowing(int userId);
}