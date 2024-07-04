using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class TagsController(ITagsRepository tagsRepository, ILogger<TagsController> logger) : ControllerBase
{
    [HttpGet()]
    [Route("search")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<TagDTO>>> SearchTags(string query)
    {
        logger.LogDebug("TagsController.SearchTags: Searching for tags with query {Query}", query);
        var tags = await tagsRepository.SearchTags(query);
        return Ok(tags);
    }

    [HttpGet()]
    [Route("{tag}/posts")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<PostDTO>>> GetPostsByTag(string tag)
    {
        logger.LogDebug("TagsController.GetPostsByTag: Getting posts for tag {Tag}", tag);
        var posts = await tagsRepository.GetPostsByTag(tag);
        return Ok(posts);
    }

    [HttpGet()]
    [Route("{tag}/stories")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<StoryDTO>>> GetStoriesByTag(string tag)
    {
        logger.LogDebug("TagsController.GetStoriesByTag: Getting stories for tag {Tag}", tag);
        var stories = await tagsRepository.GetStoriesByTag(tag);
        return Ok(stories);
    }

    [HttpPost()]
    [Route("")]
    [Authorize()]
    public async Task<ActionResult<int>> CreateTag(TagDTO tag)
    {
        logger.LogDebug("TagsController.CreateTag: Creating tag {@Tag}", tag);
        var createdTagId = await tagsRepository.CreateTag(tag);
        return Ok(createdTagId);
    }
}
