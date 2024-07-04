using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public class TagsRepository(ApplicationDbContext dbContext, ILogger<TagsRepository> logger) : ITagsRepository
{
    public async Task<IEnumerable<TagDTO>> SearchTags(string query)
    {
        logger.LogDebug("TagsRepository.SearchTags: Searching tags.");
        return await dbContext.Tags.Where(t => t.Name.Contains(query)).Select(t => t.ToDTO()).ToListAsync();
    }

    public async Task<IEnumerable<PostDTO>> GetPostsByTag(string tag)
    {
        logger.LogDebug("TagsRepository.GetPostsByTag: Getting posts by tag.");
        return await dbContext.Posts.Where(p => p.Tags.Any(t => t.Name == tag)).Select(p => p.ToDTO()).ToListAsync();
    }

    public async Task<IEnumerable<StoryDTO>> GetStoriesByTag(string tag)
    {
        logger.LogDebug("TagsRepository.GetStoriesByTag: Getting stories by tag.");
        return await dbContext.Stories.Where(s => s.Tags.Any(t => t.Name == tag)).Select(s => s.ToDTO()).ToListAsync();
    }

    public async Task<int> CreateTag(TagDTO tag)
    {
        logger.LogDebug("TagsRepository.CreateTag: Creating tag.");
        dbContext.Tags.Add(tag.ToModel());
        await dbContext.SaveChangesAsync();
        return tag.Id;
    }
}
