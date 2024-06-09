namespace UniverseBackend.Data;

public interface IPostsRepository
{
    public Task<int> AddPost(Post post);
    public Task RemovePost(int postId);
    public Task<IEnumerable<Post>> GetPosts(int userId);
    public Task<IEnumerable<Post>> GetReplies(int postId);
    public Task<int> AddReply(Post reply);
    public Task RemoveReply(int replyId);
    public Task<int> SharePost(Post post, int sharedPostId);
}