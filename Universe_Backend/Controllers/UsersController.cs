using Microsoft.AspNetCore.Mvc;
using UniverseBackend.Data;

namespace UniverseBackend.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController(IUsersRepository usersRepository, ILogger<UsersController> logger) : ControllerBase
{
    [HttpGet]
    [Route("{id}")]
    public async Task<ActionResult<User>> GetUser(int id)
    {
        User? user = await usersRepository.GetUser(id);
        return user != null ? Ok(user) : NotFound("User not found");
    }

    [HttpPost]
    [Route("")]
    public async Task<ActionResult> CreateUser(User user)
    {
        int id = await usersRepository.CreateUser(user);
        return Ok(user.ID);
    }

    [HttpGet]
    [Route("")]
    public async Task<ActionResult<IEnumerable<User>>> SearchUsers(string query)
    {
        return Ok(await usersRepository.SearchUsers(query));
    }

    [HttpGet]
    [Route("followers/{id}")]
    public async Task<ActionResult<IEnumerable<User>?>> GetFollowers(int id)
    {
        return Ok(await usersRepository.GetFollowers(id));
    }

    [HttpPost]
    [Route("followers/{followerId}/{followedId}")]
    public async Task<ActionResult> AddFollower(int followerId, int followedId)
    {
        await usersRepository.AddFollower(followerId, followedId);
        return Ok();
    }

    [HttpDelete]
    [Route("followers/{followerId}/{followedId}")]
    public async Task<ActionResult> RemoveFollower(int followerId, int followedId)
    {
        await usersRepository.RemoveFollower(followerId, followedId);
        return Ok();
    }

    [HttpGet]
    [Route("following/{id}")]
    public async Task<ActionResult<IEnumerable<User>>> GetFollowing(int id)
    {
        return Ok(await usersRepository.GetFollowing(id));
    }
}