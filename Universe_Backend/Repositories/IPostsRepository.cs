using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public interface IPostsRepository
{
    public Task<int> AddPost(Post post);
    public Task RemovePost(int postId);
    public Task<IEnumerable<Post>> GetPosts(string userId);
    public Task<IEnumerable<Post>> GetReplies(int postId);
    public Task<int> AddReply(Post reply, int postId);
    public Task RemoveReply(int replyId);
    public Task<int> SharePost(Post post, int sharedPostId);
}