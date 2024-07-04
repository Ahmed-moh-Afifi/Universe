using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public class StoriesRepository(ApplicationDbContext dbContext, ILogger<StoriesRepository> logger) : IStoriesRepository
{
    public async Task<IEnumerable<StoryDTO>> GetActiveStories(string userId)
    {
        logger.LogDebug("StoriesRepository.GetActiveStories: Getting active stories for user with id {UserId}", userId);
        try
        {
            var stories = await dbContext.Stories.Where(s => s.AuthorId == userId && s.IsActive()).ToListAsync();
            return stories.Select(s => s.ToDTO());
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoriesRepository.GetActiveStories: Error getting active stories for user with id {UserId}", userId);
            throw;
        }
    }

    public async Task<IEnumerable<StoryDTO>> GetAllStories(string userId)
    {
        logger.LogDebug("StoriesRepository.GetAllStories: Getting all stories for user with id {UserId}", userId);
        try
        {
            var stories = await dbContext.Stories.Where(s => s.AuthorId == userId).ToListAsync();
            return stories.Select(s => s.ToDTO());
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
            dbContext.Stories.Update(story.ToModel());
            await dbContext.SaveChangesAsync();
            return story;
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

    public async Task<IEnumerable<StoryDTO>> GetFollowingStories(string userId)
    {
        logger.LogDebug("StoriesRepository.GetFollowingStories: Getting following stories for user with id {UserId}", userId);
        try
        {
            var stories = await dbContext.Users.Where(u => u.Id == userId).SelectMany(u => u.Following).SelectMany(u => u.Stories).ToListAsync();
            return stories.Select(s => s.ToDTO());
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "StoriesRepository.GetFollowingStories: Error getting following stories for user with id {UserId}", userId);
            throw;
        }
    }
}
