using Microsoft.EntityFrameworkCore;

namespace UniverseBackend.Data;

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
}