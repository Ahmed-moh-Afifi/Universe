using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public interface IStoriesRepository
{
    Task<IEnumerable<StoryDTO>> GetActiveStories(string userId);
    Task<IEnumerable<StoryDTO>> GetAllStories(string userId);
    Task<StoryDTO> GetStory(int storyId);
    Task<StoryDTO> CreateStory(StoryDTO story);
    Task<StoryDTO> UpdateStory(StoryDTO story);
    Task DeleteStory(int storyId);
    Task<IEnumerable<StoryDTO>> GetFollowingStories(string userId);
}
