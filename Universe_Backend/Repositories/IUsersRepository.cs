using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public interface IUsersRepository
{
    public Task<IEnumerable<UserDTO>> SearchUsers(string query);
    public Task<UserDTO> GetUser(string id);
    public Task AddFollower(string followerId, string followedId);
    public Task RemoveFollower(string followerId, string followedId);
    public Task<IEnumerable<UserDTO>> GetFollowers(string userId);
    public Task<IEnumerable<UserDTO>> GetFollowing(string userId);
    public Task UpdateUser(UserDTO user);
    public Task<int> GetFollowersCount(string userId);
    public Task<int> GetFollowingCount(string userId);
}