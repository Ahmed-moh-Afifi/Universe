using Microsoft.AspNetCore.Mvc;
using UniverseBackend.Data;

namespace UniverseBackend.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController(ApplicationDbContext dbContext, ILogger<UsersController> logger) : ControllerBase
{
    [HttpGet]
    [Route("")]
    public ActionResult<IEnumerable<User>> GetUsers()
    {
        var users = dbContext.Set<User>().ToList();
        return Ok(users);
    }

    [HttpPost]
    [Route("")]
    public ActionResult AddUser(User user)
    {
        user.ID = 0;
        dbContext.Set<User>().Add(user);
        dbContext.SaveChanges();
        return Ok(user.ID);
    }
}