using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public interface ITagsRepository
{
    Task<IEnumerable<TagDTO>> SearchTags(string query, DateTime? lastDate, int? lastId);
    Task<IEnumerable<PostDTO>> GetPostsByTag(string tag, DateTime? lastDate, int? lastId);
    Task<IEnumerable<StoryDTO>> GetStoriesByTag(string tag, DateTime? lastDate, int? lastId);
    Task<int> CreateTag(TagDTO tag);
}
