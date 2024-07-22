using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public class StoriesRepository(ApplicationDbContext dbContext, ILogger<StoriesRepository> logger) : IStoriesRepository
{
    public async Task<IEnumerable<StoryDTO>> GetActiveStories(string userId, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("StoriesRepository.GetActiveStories: Getting active stories for user with id {UserId}", userId);
        try
        {
            List<StoryDTO> stories;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("StoriesRepository.GetActiveStories: Getting first 10 active stories for user with id {UserId}", userId);
                stories = await dbContext.Stories
                    .Where(s => s.AuthorId == userId && s.IsActive())
                    .OrderBy(s => s.PublishDate)
                    .ThenBy(s => s.Id)
                    .Select(s => s.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("StoriesRepository.GetActiveStories: Getting active stories after date {LastDate} and id {LastId} for user with id {UserId}", lastDate, lastId, userId);
                stories = await dbContext.Stories
                    .Where(s => s.AuthorId == userId && s.IsActive())
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
            logger.LogError(ex, "StoriesRepository.GetActiveStories: Error getting active stories for user with id {UserId}", userId);
            throw;
        }
    }

    public async Task<IEnumerable<StoryDTO>> GetAllStories(string userId, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("StoriesRepository.GetAllStories: Getting all stories for user with id {UserId}", userId);
        try
        {
            List<StoryDTO> stories;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("StoriesRepository.GetAllStories: Getting first 10 stories for user with id {UserId}", userId);
                stories = await dbContext.Stories
                    .Where(s => s.AuthorId == userId)
                    .OrderBy(s => s.PublishDate)
                    .ThenBy(s => s.Id)
                    .Select(s => s.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("StoriesRepository.GetAllStories: Getting stories after date {LastDate} and id {LastId} for user with id {UserId}", lastDate, lastId, userId);
                stories = await dbContext.Stories
                    .Where(s => s.AuthorId == userId)
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
            logger.LogError(ex, "StoriesRepository.GetAllStories: Error getting all stories for user with id {UserId}", userId);
            throw;
        }
    }

    public async Task<StoryDTO> GetStory(int storyId)
    {
        logger.LogDebug("StoriesRepository.GetStory: Getting story with id {StoryId}", storyId);
        try
        {
            var story = await dbContext.Stories.FindAsync(storyId);

            if (story == null)
            {
                // throw NotFoundException().
            }

            return story!.ToDTO()!;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoriesRepository.GetStory: Error getting story with id {StoryId}", storyId);
            throw;
        }
    }

    public async Task<StoryDTO> CreateStory(StoryDTO story)
    {
        logger.LogDebug("StoriesRepository.CreateStory: Creating story {@Story}", story);
        try
        {
            await dbContext.Stories.AddAsync(story.ToModel());
            await dbContext.SaveChangesAsync();
            return story;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoriesRepository.CreateStory: Error creating story {@Story}", story);
            throw;
        }
    }

    public async Task<StoryDTO> UpdateStory(StoryDTO story)
    {
        logger.LogDebug("StoriesRepository.UpdateStory: Updating story {@Story}", story);
        try
        {
            var existingStory = await dbContext.Stories.FindAsync(story.Id);
            if (existingStory == null)
            {
                // throw NotFoundException().
            }

            var updated = dbContext.Stories.Update(existingStory!.UpdateFromDTO(story));
            await dbContext.SaveChangesAsync();

            return updated.Entity.ToDTO();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoriesRepository.UpdateStory: Error updating story {@Story}", story);
            throw;
        }
    }

    public async Task DeleteStory(int storyId)
    {
        logger.LogDebug("StoriesRepository.DeleteStory: Deleting story with id {StoryId}", storyId);
        try
        {
            var story = await dbContext.Stories.FindAsync(storyId);
            if (story == null)
            {
                // throw NotFoundException().
            }

            dbContext.Stories.Remove(story!);
            await dbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoriesRepository.DeleteStory: Error deleting story with id {StoryId}", storyId);
            throw;
        }
    }

    public async Task<IEnumerable<StoryDTO>> GetFollowingStories(string userId, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("StoriesRepository.GetFollowingStories: Getting following stories for user with id {UserId}", userId);
        try
        {
            List<StoryDTO> stories;
            if (lastDate == null && lastId == null)
            {
                logger.LogDebug("StoriesRepository.GetFollowingStories: Getting first 10 following stories for user with id {UserId}", userId);
                stories = await dbContext.Users
                    .Where(u => u.Id == userId)
                    .SelectMany(u => u.Following)
                    .SelectMany(u => u.Stories)
                    .Where(u => u.IsActive())
                    .OrderBy(s => s.PublishDate)
                    .ThenBy(s => s.Id)
                    .Select(s => s.ToDTO())
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                logger.LogDebug("StoriesRepository.GetFollowingStories: Getting following stories after date {LastDate} and id {LastId} for user with id {UserId}", lastDate, lastId, userId);
                stories = await dbContext.Users
                    .Where(u => u.Id == userId)
                    .SelectMany(u => u.Following)
                    .SelectMany(u => u.Stories)
                    .Where(u => u.IsActive())
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
            logger.LogError(ex, "StoriesRepository.GetFollowingStories: Error getting following stories for user with id {UserId}", userId);
            throw;
        }
    }

    public async Task<IEnumerable<UserDTO>> GetFollowingWithActiveStories(string userId)
    {
        logger.LogDebug("StoriesRepository.GetFollowingWithActiveStories: Getting following with active stories for user with id {UserId}", userId);
        try
        {
            var following = await dbContext.Users
                .Where(u => u.Id == userId)
                .SelectMany(u => u.Following)
                .SelectMany(u => u.Stories)
                .Where(u => u.IsActive())
                .OrderBy(s => s.PublishDate)
                .ThenBy(s => s.Id)
                .Select(s => s.Author!.ToDTO())
                .ToListAsync();

            return following;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoriesRepository.GetFollowingWithActiveStories: Error getting following with active stories for user with id {UserId}", userId);
            throw;
        }
    }
}
