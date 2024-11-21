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
    [Route("Search")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<TagDTO>>> SearchTags(string query, DateTime lastDate, int lastId)
    {
        logger.LogDebug("TagsController.SearchTags: Searching for tags with query {Query}", query);
        var tags = await tagsRepository.SearchTags(query, lastDate, lastId);
        return Ok(tags);
    }

    [HttpGet()]
    [Route("{tag}/Posts")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<PostDTO>>> GetPostsByTag(string tag, DateTime lastDate, int lastId)
    {
        logger.LogDebug("TagsController.GetPostsByTag: Getting posts for tag {Tag}", tag);
        var posts = await tagsRepository.GetPostsByTag(tag, lastDate, lastId);
        return Ok(posts);
    }

    [HttpGet()]
    [Route("{tag}/Stories")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<StoryDTO>>> GetStoriesByTag(string tag, DateTime lastDate, int lastId)
    {
        logger.LogDebug("TagsController.GetStoriesByTag: Getting stories for tag {Tag}", tag);
        var stories = await tagsRepository.GetStoriesByTag(tag, lastDate, lastId);
        return Ok(stories);
    }

    [HttpPost()]
    [Route("")]
    [Authorize()]
    public async Task<ActionResult<int>> CreateTag([FromBody] TagDTO tag)
    {
        logger.LogDebug("TagsController.CreateTag: Creating tag {@Tag}", tag);
        var createdTagId = await tagsRepository.CreateTag(tag);
        return Ok(createdTagId);
    }
}
