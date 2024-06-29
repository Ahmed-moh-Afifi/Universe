using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController(IUsersRepository usersRepository, ILogger<UsersController> logger) : ControllerBase
{
    [HttpGet]
    [Route("{id}")]
    public async Task<ActionResult<User>> GetUser(string id)
    {
        logger.LogDebug("UsersController.GetUser: Getting user with id: {id}", id);
        User? user = await usersRepository.GetUser(id);
        return user != null ? Ok(user) : NotFound("User not found");
    }

    [HttpGet]
    [Route("")]
    public async Task<ActionResult<IEnumerable<User>>> SearchUsers(string query)
    {
        logger.LogDebug("UsersController.SearchUsers: Searching for users with query: {query}", query);
        return Ok(await usersRepository.SearchUsers(query));
    }

    [HttpGet]
    [Route("followers/{id}")]
    public async Task<ActionResult<IEnumerable<User>?>> GetFollowers(string id)
    {
        logger.LogDebug("UsersController.GetFollowers: Getting followers of user with id: {id}", id);
        return Ok(await usersRepository.GetFollowers(id));
    }

    [HttpGet]
    [Route("following/{id}")]
    public async Task<ActionResult<IEnumerable<User>>> GetFollowing(string id)
    {
        logger.LogDebug("UsersController.GetFollowing: Getting users followed by user with id: {id}", id);
        return Ok(await usersRepository.GetFollowing(id));
    }

    [HttpPost]
    [Route("followers/{followerId}/{followedId}")]
    public async Task<ActionResult> AddFollower(string followerId, string followedId)
    {
        logger.LogDebug("UsersController.AddFollower: Adding follower with id: {followerId} to user with id: {followedId}", followerId, followedId);
        await usersRepository.AddFollower(followerId, followedId);
        return Ok();
    }

    [HttpDelete]
    [Route("followers/{followerId}/{followedId}")]
    public async Task<ActionResult> RemoveFollower(string followerId, string followedId)
    {
        logger.LogDebug("UsersController.RemoveFollower: Removing follower with id: {followerId} from user with id: {followedId}", followerId, followedId);
        await usersRepository.RemoveFollower(followerId, followedId);
        return Ok();
    }

    [HttpGet]
    [Route("followers/count/{id}")]
    public async Task<ActionResult<int>> GetFollowersCount(string id)
    {
        logger.LogDebug("UsersController.GetFollowersCount: Getting followers count for user with id: {id}", id);
        return Ok(await usersRepository.GetFollowersCount(id));
    }

    [HttpGet]
    [Route("following/count/{id}")]
    public async Task<ActionResult<int>> GetFollowingCount(string id)
    {
        logger.LogDebug("UsersController.GetFollowingCount: Getting following count for user with id: {id}", id);
        return Ok(await usersRepository.GetFollowingCount(id));
    }

    [HttpPut]
    [Route("")]
    public async Task<ActionResult> UpdateUser(User user)
    {
        logger.LogDebug("UsersController.UpdateUser: Updating user {@User}", user);
        await usersRepository.UpdateUser(user);
        return Ok();
    }
}