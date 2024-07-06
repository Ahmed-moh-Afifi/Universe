using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController(IUsersRepository usersRepository, ILogger<UsersController> logger) : ControllerBase
{
    [HttpGet]
    [Route("{userId}")]
    [Authorize()]
    public async Task<ActionResult<UserDTO>> GetUser(string userId)
    {
        logger.LogDebug("UsersController.GetUser: Getting user with id: {userId}", userId);
        UserDTO? user = await usersRepository.GetUser(userId);
        return user != null ? Ok(user) : NotFound("User not found");
    }

    [HttpGet]
    [Route("")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<UserDTO>>> SearchUsers(string query, DateTime? lastDate, string? lastId)
    {
        logger.LogDebug("UsersController.SearchUsers: Searching for users with query: {query}", query);
        return Ok(await usersRepository.SearchUsers(query, lastDate, lastId));
    }

    [HttpGet]
    [Route("{userId}/followers")]
    [Authorize(Policy = "IsFollower")]
    public async Task<ActionResult<IEnumerable<UserDTO>?>> GetFollowers(string userId, DateTime? lastDate, string? lastId)
    {
        logger.LogDebug("UsersController.GetFollowers: Getting followers of user with id: {id}", userId);
        return Ok(await usersRepository.GetFollowers(userId, lastDate, lastId));
    }

    [HttpGet]
    [Route("{userId}/following")]
    [Authorize(Policy = "IsFollower")]
    public async Task<ActionResult<IEnumerable<UserDTO>>> GetFollowing(string userId, DateTime? lastDate, string? lastId)
    {
        logger.LogDebug("UsersController.GetFollowing: Getting users followed by user with id: {id}", userId);
        return Ok(await usersRepository.GetFollowing(userId, lastDate, lastId));
    }

    [HttpPost]
    [Route("{followedId}/followers/{followerId}")]
    [Authorize()]
    public async Task<ActionResult> AddFollower(string followerId, string followedId)
    {
        logger.LogDebug("UsersController.AddFollower: Adding follower with id: {followerId} to user with id: {followedId}", followerId, followedId);
        await usersRepository.AddFollower(followerId, followedId);
        return Ok();
    }

    [HttpDelete]
    [Route("{followedId}/followers/{followerId}")]
    [Authorize()]
    public async Task<ActionResult> RemoveFollower(string followerId, string followedId)
    {
        logger.LogDebug("UsersController.RemoveFollower: Removing follower with id: {followerId} from user with id: {followedId}", followerId, followedId);
        await usersRepository.RemoveFollower(followerId, followedId);
        return Ok();
    }

    [HttpGet]
    [Route("{userId}/followers/count")]
    [Authorize()]
    public async Task<ActionResult<int>> GetFollowersCount(string userId)
    {
        logger.LogDebug("UsersController.GetFollowersCount: Getting followers count for user with id: {id}", userId);
        return Ok(await usersRepository.GetFollowersCount(userId));
    }

    [HttpGet]
    [Route("{userId}following/count")]
    [Authorize()]
    public async Task<ActionResult<int>> GetFollowingCount(string userId)
    {
        logger.LogDebug("UsersController.GetFollowingCount: Getting following count for user with id: {id}", userId);
        return Ok(await usersRepository.GetFollowingCount(userId));
    }

    [HttpPut]
    [Route("")]
    [Authorize(Policy = "Owner")]
    public async Task<ActionResult> UpdateUser(UserDTO user)
    {
        logger.LogDebug("UsersController.UpdateUser: Updating user {@User}", user);
        await usersRepository.UpdateUser(user);
        return Ok();
    }
}