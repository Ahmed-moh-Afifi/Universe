﻿using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class StoriesController(IStoriesRepository storiesRepository, IStoryReactionsRepository reactionsRepository, IAuthorizationService authorizationService, ILogger<StoriesController> logger) : ControllerBase
{
    [HttpGet()]
    [Route("active")]
    public async Task<ActionResult<IEnumerable<StoryDTO>>> GetActiveStories(string userId)
    {
        logger.LogDebug("StoriesController.GetStories: Getting stories for user with id {UserId}", userId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("StoriesController.GetStories: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        var stories = await storiesRepository.GetActiveStories(userId);
        return Ok(stories);
    }

    [HttpGet()]
    [Route("all")]
    public async Task<ActionResult<IEnumerable<StoryDTO>>> GetAllStories(string userId)
    {
        logger.LogDebug("StoriesController.GetAllStories: Getting all stories for user with id {UserId}", userId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(userId, typeof(Story)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("StoriesController.GetAllStories: User with id {UserId} is not the owner of user with id {OwnerId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        var stories = await storiesRepository.GetAllStories(userId);
        return Ok(stories);
    }

    [HttpGet()]
    [Route("following")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<StoryDTO>>> GetFollowingStories()
    {
        logger.LogDebug("StoriesController.GetFollowingStories: Getting following stories for user with id {UserId}", User.FindFirstValue("uid"));
        var stories = await storiesRepository.GetFollowingStories(User.FindFirstValue("uid")!);
        return Ok(stories);
    }

    [HttpGet()]
    [Route("{userId}/{storyId}")]
    public async Task<ActionResult<StoryDTO>> GetStory(string userId, int storyId)
    {
        logger.LogDebug("StoriesController.GetStory: Getting story with id {StoryId}", storyId);
        // Validate route parameters.
        var isFollowerResult = await authorizationService.AuthorizeAsync(User, storyId.ToString(), "IsFollower");
        if (!isFollowerResult.Succeeded)
        {
            logger.LogWarning("StoriesController.GetStory: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        var story = await storiesRepository.GetStory(storyId);

        if (!story.ToModel().IsActive())
        {
            logger.LogWarning("StoriesController.GetStory: Story with id {StoryId} is not active", storyId);
            var isOwnerResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(userId, typeof(Story)), "IsOwner");

            if (!isOwnerResult.Succeeded)
            {
                logger.LogWarning("StoriesController.GetStory: User with id {UserId} is not the owner of story with id {StoryId}", User.FindFirstValue("uid"), storyId);
                return Unauthorized();
            }
        }

        return Ok(story);
    }

    [HttpPost()]
    [Route("{userId}")]
    [Authorize()]
    public async Task<ActionResult<StoryDTO>> CreateStory([FromBody] StoryDTO story, string userId)
    {
        logger.LogDebug("StoriesController.CreateStory: Creating story {@Story}", story);
        // Validate route parameters.
        if (story.AuthorId != User.FindFirstValue("uid"))
        {
            logger.LogWarning("StoriesController.CreateStory: User with id {UserId} tried to create story with author id {AuthorId}", User.FindFirstValue("uid"), story.AuthorId);
            return Unauthorized();
        }
        var createdStory = await storiesRepository.CreateStory(story);
        return Ok(createdStory);
    }

    [HttpPut()]
    [Route("{userId}/{storyId}")]
    public async Task<ActionResult> UpdateStory([FromBody] StoryDTO story, string userId, int storyId)
    {
        logger.LogDebug("StoriesController.UpdateStory: Updating story {@Story}", story);
        // Validate route parameters.
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(story.Id.ToString(), typeof(Story)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("StoriesController.UpdateStory: User with id {UserId} is not the owner of story with id {StoryId}", User.FindFirstValue("uid"), story.Id);
            return Unauthorized();
        }

        return Ok(await storiesRepository.UpdateStory(story));
    }

    [HttpDelete()]
    [Route("{storyId}")]
    public async Task<IActionResult> DeleteStory(int storyId)
    {
        logger.LogDebug("StoriesController.DeleteStory: Deleting story with id {StoryId}", storyId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(storyId.ToString(), typeof(Story)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("StoriesController.DeleteStory: User with id {UserId} is not the owner of story with id {StoryId}", User.FindFirstValue("uid"), storyId);
            return Unauthorized();
        }

        await storiesRepository.DeleteStory(storyId);
        return Ok();
    }

    [HttpGet()]
    [Route("{storyId}/reactions")]
    public async Task<ActionResult<IEnumerable<StoryReactionDTO>>> GetReactions(int storyId)
    {
        logger.LogDebug("StoriesController.GetReactions: Getting reactions for story with id {StoryId}", storyId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(storyId.ToString(), typeof(Story)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("StoriesController.GetReactions: User with id {UserId} is not the owner of story with id {StoryId}", User.FindFirstValue("uid"), storyId);
            return Unauthorized();
        }

        var reactions = await reactionsRepository.GetReactions(storyId);
        return Ok(reactions);
    }

    [HttpPost()]
    [Route("{storyId}/reactions")]
    public async Task<ActionResult> AddReaction(int storyId, [FromBody] StoryReactionDTO reaction)
    {
        logger.LogDebug("StoriesController.AddReaction: Adding reaction {@Reaction} to story with id {StoryId}", reaction, storyId);
        // Validate route parameters.
        if (reaction.UserId != User.FindFirstValue("uid"))
        {
            logger.LogWarning("StoriesController.AddReaction: User with id {UserId} tried to add reaction with user id {ReactionUserId}", User.FindFirstValue("uid"), reaction.UserId);
            return Unauthorized();
        }

        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(storyId.ToString(), typeof(Story)), "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("StoriesController.AddReaction: User with id {UserId} is not a follower of story with id {StoryId}", User.FindFirstValue("uid"), storyId);
            return Unauthorized();
        }

        await reactionsRepository.AddReaction(reaction);
        return Ok();
    }

    [HttpDelete()]
    [Route("{storyId}/reactions/{reactionId}")]
    public async Task<ActionResult> DeleteReaction(int storyId, int reactionId)
    {
        logger.LogDebug("StoriesController.RemoveReaction: Removing reaction with id {ReactionId}", reactionId);
        // Validate route parameters.
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(reactionId.ToString(), typeof(StoryReaction)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("StoriesController.RemoveReaction: User with id {UserId} is not the owner of reaction with id {ReactionId}", User.FindFirstValue("uid"), reactionId);
            return Unauthorized();
        }

        await reactionsRepository.RemoveReaction(reactionId);
        return Ok();
    }

    [HttpGet()]
    [Route("{storyId}/reactions/count")]
    public async Task<ActionResult<int>> GetReactionsCount(int storyId)
    {
        logger.LogDebug("StoriesController.GetReactionsCount: Getting reactions count for story with id {StoryId}", storyId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(storyId.ToString(), typeof(Story)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("StoriesController.GetReactionsCount: User with id {UserId} is not the owner of story with id {StoryId}", User.FindFirstValue("uid"), storyId);
            return Unauthorized();
        }

        var count = await reactionsRepository.GetReactionsCount(storyId);
        return Ok(count);
    }
}