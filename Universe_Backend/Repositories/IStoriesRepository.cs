using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public interface IStoriesRepository
{
    Task<IEnumerable<Story>> GetActiveStories(string userId);
    Task<IEnumerable<Story>> GetAllStories(string userId);
    Task<Story> GetStory(int storyId);
    Task<Story> CreateStory(Story story);
    Task<Story> UpdateStory(Story story);
    Task DeleteStory(int storyId);
    Task<IEnumerable<Story>> GetFollowingStories(string userId);
}
