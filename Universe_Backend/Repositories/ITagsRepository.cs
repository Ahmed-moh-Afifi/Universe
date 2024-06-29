using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public interface ITagsRepository
{
    Task<IEnumerable<Tag>> SearchTags(string query);
    Task<IEnumerable<Post>> GetPostsByTag(string tag);
    Task<IEnumerable<Story>> GetStoriesByTag(string tag);
    Task<int> CreateTag(Tag tag);
}
