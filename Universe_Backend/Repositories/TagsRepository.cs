using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public class TagsRepository(ApplicationDbContext dbContext, ILogger<TagsRepository> logger) : ITagsRepository
{
    public async Task<IEnumerable<Tag>> SearchTags(string query)
    {
        logger.LogDebug("TagsRepository.SearchTags: Searching tags.");
        return await dbContext.Tags.Where(t => t.Name.Contains(query)).ToListAsync();
    }

    public async Task<IEnumerable<Post>> GetPostsByTag(string tag)
    {
        logger.LogDebug("TagsRepository.GetPostsByTag: Getting posts by tag.");
        return await dbContext.Posts.Where(p => p.Tags.Any(t => t.Name == tag)).ToListAsync();
    }

    public async Task<IEnumerable<Story>> GetStoriesByTag(string tag)
    {
        logger.LogDebug("TagsRepository.GetStoriesByTag: Getting stories by tag.");
        return await dbContext.Stories.Where(s => s.Tags.Any(t => t.Name == tag)).ToListAsync();
    }

    public async Task<int> CreateTag(Tag tag)
    {
        logger.LogDebug("TagsRepository.CreateTag: Creating tag.");
        dbContext.Tags.Add(tag);
        await dbContext.SaveChangesAsync();
        return tag.Id;
    }
}
