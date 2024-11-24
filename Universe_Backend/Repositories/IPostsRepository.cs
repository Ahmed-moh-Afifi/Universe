using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Repositories;

public interface IPostsRepository
{
    public Task<int> AddPost(PostDTO post);
    public Task<PostDTO> GetPost(int postId, string callerId);
    public Task<PostDTO> UpdatePost(PostDTO post);
    public Task RemovePost(int postId);
    public IEnumerable<PostDTO> GetReplies(int postId, string callerId, DateTime? lastDate, int? lastId);
    public IEnumerable<PostDTO> GetPosts(string userId, string callerId, DateTime? lastDate, int? lastId);
    public Task<int> AddReply(PostDTO reply, int postId);
    public Task RemoveReply(int replyId);
    public Task<int> SharePost(PostDTO post, int sharedPostId);
    public Task<int> GetPostsCount(string userId);
    public IEnumerable<PostDTO> GetFollowingPosts(string userId, string callerId, DateTime? lastDate, int? lastId);
    public Task<UserDTO> GetPostAuthor(int postId);
}