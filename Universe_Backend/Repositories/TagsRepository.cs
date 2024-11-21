using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public class TagsRepository(ApplicationDbContext dbContext, ILogger<TagsRepository> logger) : ITagsRepository
{
    public async Task<IEnumerable<TagDTO>> SearchTags(string query, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("TagsRepository.SearchTags: Searching tags.");
        try
        {
            List<TagDTO> tags;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("TagsRepository.SearchTags: Getting first 10 tags.");
                tags = await dbContext.Tags
                    .Where(t => t.Name.Contains(query) || query.Contains(t.Name))
                    .OrderBy(t => t.CreateDate)
                    .ThenBy(t => t.Id)
                    .Select(t => t.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("TagsRepository.SearchTags: Getting tags after date {LastDate} and id {LastId}.", lastDate, lastId);
                tags = await dbContext.Tags
                    .Where(t => t.Name.Contains(query) || query.Contains(t.Name))
                    .OrderBy(t => t.CreateDate)
                    .ThenBy(t => t.Id)
                    .Where(t => t.CreateDate > lastDate || (t.CreateDate == lastDate && t.Id > lastId))
                    .Select(t => t.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }

            return tags;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "TagsRepository.SearchTags: Error searching tags.");
            throw;
        }
    }

    public async Task<IEnumerable<PostDTO>> GetPostsByTag(string tag, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("TagsRepository.GetPostsByTag: Getting posts by tag.");
        try
        {
            List<PostDTO> posts;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("TagsRepository.GetPostsByTag: Getting first 10 posts by tag.");
                posts = await dbContext.Posts
                    .Where(p => p.Tags.Any(t => t.Name == tag))
                    .OrderBy(p => p.PublishDate)
                    .ThenBy(p => p.Id)
                    .Select(p => p.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("TagsRepository.GetPostsByTag: Getting posts by tag after date {LastDate} and id {LastId}.", lastDate, lastId);
                posts = await dbContext.Posts
                    .Where(p => p.Tags.Any(t => t.Name == tag))
                    .OrderBy(p => p.PublishDate)
                    .ThenBy(p => p.Id)
                    .Where(p => p.PublishDate > lastDate || (p.PublishDate == lastDate && p.Id > lastId))
                    .Select(p => p.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }

            return posts;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "TagsRepository.GetPostsByTag: Error getting posts by tag.");
            throw;
        }
    }

    public async Task<IEnumerable<StoryDTO>> GetStoriesByTag(string tag, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("TagsRepository.GetStoriesByTag: Getting stories by tag.");
        try
        {
            List<StoryDTO> stories;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("TagsRepository.GetStoriesByTag: Getting first 10 stories by tag.");
                stories = await dbContext.Stories
                    .Where(s => s.Tags.Any(t => t.Name == tag))
                    .OrderBy(s => s.PublishDate)
                    .ThenBy(s => s.Id)
                    .Select(s => s.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("TagsRepository.GetStoriesByTag: Getting stories by tag after date {LastDate} and id {LastId}.", lastDate, lastId);
                stories = await dbContext.Stories
                    .Where(s => s.Tags.Any(t => t.Name == tag))
                    .OrderBy(s => s.PublishDate)
                    .ThenBy(s => s.Id)
                    .Where(s => s.PublishDate > lastDate || (s.PublishDate == lastDate && s.Id > lastId))
                    .Select(s => s.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }

            return stories;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "TagsRepository.GetStoriesByTag: Error getting stories by tag.");
            throw;
        }
    }

    public async Task<int> CreateTag(TagDTO tag)
    {
        logger.LogDebug("TagsRepository.CreateTag: Creating tag.");
        dbContext.Tags.Add(tag.ToModel());
        await dbContext.SaveChangesAsync();
        return tag.Id;
    }
}
