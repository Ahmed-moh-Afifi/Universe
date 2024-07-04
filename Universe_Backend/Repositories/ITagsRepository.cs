using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public interface ITagsRepository
{
    Task<IEnumerable<TagDTO>> SearchTags(string query);
    Task<IEnumerable<PostDTO>> GetPostsByTag(string tag);
    Task<IEnumerable<StoryDTO>> GetStoriesByTag(string tag);
    Task<int> CreateTag(TagDTO tag);
}
