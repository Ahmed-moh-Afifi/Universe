namespace UniverseBackend.Data;

public interface IUsersRepository
{
    public Task<int> CreateUser(User user);
    public Task<List<User>> SearchUsers(string query);
    public Task<User?> GetUser(int id);
}