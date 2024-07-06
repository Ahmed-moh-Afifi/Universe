using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public interface IPostsRepository
{
    public Task<int> AddPost(PostDTO post);
    public Task<PostDTO> UpdatePost(PostDTO post);
    public Task RemovePost(int postId);
    public Task<IEnumerable<PostDTO>> GetPosts(string userId);
    public Task<IEnumerable<PostDTO>> GetReplies(int postId);
    public Task<int> AddReply(PostDTO reply, int postId);
    public Task RemoveReply(int replyId);
    public Task<int> SharePost(PostDTO post, int sharedPostId);
    public Task<int> GetPostsCount(string userId);
    public Task<IEnumerable<PostDTO>> GetFollowingPosts(string userId);
}