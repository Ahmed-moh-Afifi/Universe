using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController(IUsersRepository usersRepository, NotificationService.NotificationService notificationService, ILogger<UsersController> logger) : ControllerBase
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
    public async Task<ActionResult<IEnumerable<UserDTO>>> SearchUsers(string query/*, [FromBody] UsersApiCallStart apiCallStart*/)
    {
        logger.LogDebug("UsersController.SearchUsers: Searching for users with query: {query}", query);
        return Ok(await usersRepository.SearchUsers(query, null, null));
    }

    [HttpGet]
    [Route("{userId}/Followers")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<UserDTO>?>> GetFollowers(string userId, [FromBody] UsersApiCallStart apiCallStart)
    {
        logger.LogDebug("UsersController.GetFollowers: Getting followers of user with id: {id}", userId);
        return Ok(await usersRepository.GetFollowers(userId, apiCallStart.LastDate, apiCallStart.LastId));
    }

    [HttpGet]
    [Route("{userId}/Following")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<UserDTO>>> GetFollowing(string userId, [FromBody] UsersApiCallStart apiCallStart)
    {
        logger.LogDebug("UsersController.GetFollowing: Getting users followed by user with id: {id}", userId);
        return Ok(await usersRepository.GetFollowing(userId, apiCallStart.LastDate, apiCallStart.LastId));
    }

    [HttpPost]
    [Route("{followedId}/Followers/{followerId}")]
    [Authorize()]
    public async Task<ActionResult> AddFollower(string followerId, string followedId)
    {
        logger.LogDebug("UsersController.AddFollower: Adding follower with id: {followerId} to user with id: {followedId}", followerId, followedId);
        await usersRepository.AddFollower(followerId, followedId);

        logger.LogDebug("UsersController.AddFollower: Getting notification token for follower with id: {followerId}", followerId);
        var notificationTokens = await usersRepository.GetNotificationTokens(followerId);

        logger.LogDebug("UsersController.AddFollower: Got notification token: {@notificationTokens}", notificationTokens);
        if (notificationTokens != null)
        {
            logger.LogDebug("UsersController.AddFollower: Subscribing follower to topic with id: {followedId}", followedId);
            await notificationService.SubscribeToTopicAsync(notificationTokens.Select(nt => nt.Token).ToList(), followedId.ToString(), NotificationService.Models.Platform.Android);
        }

        return Ok();
    }

    [HttpDelete]
    [Route("{followedId}/Followers/{followerId}")]
    [Authorize()]
    public async Task<ActionResult> RemoveFollower(string followerId, string followedId)
    {
        logger.LogDebug("UsersController.RemoveFollower: Removing follower with id: {followerId} from user with id: {followedId}", followerId, followedId);
        await usersRepository.RemoveFollower(followerId, followedId);
        return Ok();
    }

    [HttpGet]
    [Route("{userId}/Followers/Count")]
    [Authorize()]
    public async Task<ActionResult<int>> GetFollowersCount(string userId)
    {
        logger.LogDebug("UsersController.GetFollowersCount: Getting followers count for user with id: {id}", userId);
        return Ok(await usersRepository.GetFollowersCount(userId));
    }

    [HttpGet]
    [Route("{userId}/Following/Count")]
    [Authorize()]
    public async Task<ActionResult<int>> GetFollowingCount(string userId)
    {
        logger.LogDebug("UsersController.GetFollowingCount: Getting following count for user with id: {id}", userId);
        return Ok(await usersRepository.GetFollowingCount(userId));
    }

    [HttpPut]
    [Route("{userId}")]
    [Authorize()]
    public async Task<ActionResult> UpdateUser(string userId, [FromBody] UserDTO user)
    {
        logger.LogDebug("UsersController.UpdateUser: Updating user {@User}", user);
        await usersRepository.UpdateUser(user);
        return Ok();
    }

    [HttpGet]
    [Route("Username/{userName}/Available")]
    public async Task<ActionResult<bool>> IsUserNameAvailable(string userName)
    {
        logger.LogDebug("UsersController.IsUserNameAvailable: Checking if username {userName} is available", userName);
        return Ok(await usersRepository.IsUserNameAvailable(userName));
    }

    [HttpGet]
    [Route("{userOneId}/Following/{userTwoId}/Exists")]
    public async Task<ActionResult<bool>> IsUserOneFollowingUserTwo(string userOneId, string userTwoId)
    {
        logger.LogDebug("UsersController.IsUserOneFollowingUserTwo: Checking if user with id: {userOneId} is following user with id: {userTwoId}", userOneId, userTwoId);
        return Ok(await usersRepository.IsUserOneFollowingUserTwo(userOneId, userTwoId));
    }
}