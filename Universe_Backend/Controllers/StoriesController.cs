using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class StoriesController(IStoriesRepository storiesRepository, IStoryReactionsRepository reactionsRepository, ILogger<StoriesController> logger) : ControllerBase
{
    [HttpGet()]
    [Route("active")]
    [Authorize(Policy = "IsFollower")]
    public async Task<ActionResult<IEnumerable<StoryDTO>>> GetActiveStories(string userId)
    {
        logger.LogDebug("StoriesController.GetStories: Getting stories for user with id {UserId}", userId);
        var stories = await storiesRepository.GetActiveStories(userId);
        return Ok(stories);
    }

    [HttpGet()]
    [Route("all")]
    [Authorize(Policy = "IsFollower")]
    public async Task<ActionResult<IEnumerable<StoryDTO>>> GetAllStories(string userId)
    {
        logger.LogDebug("StoriesController.GetAllStories: Getting all stories for user with id {UserId}", userId);
        var stories = await storiesRepository.GetAllStories(userId);
        return Ok(stories);
    }

    [HttpGet()]
    [Route("{storyId}")]
    [Authorize()]
    public async Task<ActionResult<StoryDTO>> GetStory(int storyId)
    {
        logger.LogDebug("StoriesController.GetStory: Getting story with id {StoryId}", storyId);
        var story = await storiesRepository.GetStory(storyId);
        return Ok(story);
    }

    [HttpPost()]
    [Route("")]
    [Authorize()]
    public async Task<ActionResult<StoryDTO>> CreateStory(StoryDTO story)
    {
        logger.LogDebug("StoriesController.CreateStory: Creating story {@Story}", story);
        var createdStory = await storiesRepository.CreateStory(story);
        return Ok(createdStory);
    }

    [HttpPut()]
    [Route("")]
    [Authorize(Policy = "Owner")]
    public async Task<ActionResult> UpdateStory(StoryDTO story)
    {
        logger.LogDebug("StoriesController.UpdateStory: Updating story {@Story}", story);
        var updatedStory = await storiesRepository.UpdateStory(story);
        return Ok();
    }

    [HttpDelete()]
    [Route("{storyId}")]
    [Authorize(Policy = "Owner")]
    public async Task<IActionResult> DeleteStory(int storyId)
    {
        logger.LogDebug("StoriesController.DeleteStory: Deleting story with id {StoryId}", storyId);
        await storiesRepository.DeleteStory(storyId);
        return Ok();
    }

    [HttpGet()]
    [Route("{storyId}/reactions")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<StoryReactionDTO>>> GetReactions(int storyId)
    {
        logger.LogDebug("StoriesController.GetReactions: Getting reactions for story with id {StoryId}", storyId);
        var reactions = await reactionsRepository.GetReactions(storyId);
        return Ok(reactions);
    }

    [HttpPost()]
    [Route("{storyId}/reactions")]
    [Authorize()]
    public async Task<ActionResult> AddReaction(int storyId, StoryReactionDTO reaction)
    {
        logger.LogDebug("StoriesController.AddReaction: Adding reaction {@Reaction} to story with id {StoryId}", reaction, storyId);
        await reactionsRepository.AddReaction(reaction);
        return Ok();
    }

    [HttpDelete()]
    [Route("/reactions/{reactionId}")]
    [Authorize()]
    public async Task<ActionResult> RemoveReaction(int reactionId)
    {
        logger.LogDebug("StoriesController.RemoveReaction: Removing reaction with id {ReactionId}", reactionId);
        await reactionsRepository.RemoveReaction(reactionId);
        return Ok();
    }

    [HttpGet()]
    [Route("{storyId}/reactions/count")]
    [Authorize()]
    public async Task<ActionResult<int>> GetReactionsCount(int storyId)
    {
        logger.LogDebug("StoriesController.GetReactionsCount: Getting reactions count for story with id {StoryId}", storyId);
        var count = await reactionsRepository.GetReactionsCount(storyId);
        return Ok(count);
    }
}