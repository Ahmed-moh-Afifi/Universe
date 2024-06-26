using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public class PostsRepository(ApplicationDbContext dbContext, ILogger<PostsRepository> logger) : IPostsRepository
{
    public async Task<int> AddPost(Post post)
    {
        logger.LogDebug("PostsRepository.AddPost: Adding post {@Post}", post);
        try
        {
            await dbContext.Posts.AddAsync(post);
            await dbContext.SaveChangesAsync();
            return post.Id;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.AddPost: Error adding post {@Post}", post);
            throw;
        }
    }

    public async Task RemovePost(int postId)
    {
        logger.LogDebug("PostsRepository.RemovePost: Removing post with id {PostId}", postId);
        try
        {
            var post = await dbContext.Posts.FindAsync(postId);
            if (post == null)
            {
                logger.LogWarning("PostsRepository.RemovePost: Post with id {PostId} not found", postId);
                return;
            }

            dbContext.Posts.Remove(post!);
            await dbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.RemovePost: Error removing post with id {PostId}", postId);
            throw;
        }
    }

    public async Task<IEnumerable<Post>> GetPosts(string userId)
    {
        logger.LogDebug("PostsRepository.GetPosts: Getting posts for user with id {UserId}", userId);
        try
        {
            var posts = await dbContext.Posts.Where(p => p.AuthorId == userId).ToListAsync();
            return posts;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.GetPosts: Error getting posts for user with id {UserId}", userId);
            throw;
        }
    }

    public async Task<IEnumerable<Post>> GetReplies(int postId)
    {
        logger.LogDebug("PostsRepository.GetReplies: Getting replies for post with id {PostId}", postId);
        try
        {
            var replies = await dbContext.Posts.Where(p => p.ReplyToPost == postId).ToListAsync();
            return replies;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.GetReplies: Error getting replies for post with id {PostId}", postId);
            throw;
        }
    }

    public async Task<int> AddReply(Post reply, int postId)
    {
        logger.LogDebug("PostsRepository.AddReply: Adding reply {@Reply} to post with id {PostId}", reply, postId);
        try
        {
            reply.ReplyToPost = postId;
            await dbContext.Posts.AddAsync(reply);
            await dbContext.SaveChangesAsync();
            return reply.Id;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.AddReply: Error adding reply {@Reply} to post with id {PostId}", reply, postId);
            throw;
        }
    }

    public async Task RemoveReply(int replyId)
    {
        logger.LogDebug("PostsRepository.RemoveReply: Removing reply with id {ReplyId}", replyId);
        try
        {
            var reply = await dbContext.Posts.FindAsync(replyId);
            if (reply == null)
            {
                logger.LogWarning("PostsRepository.RemoveReply: Reply with id {ReplyId} not found", replyId);
                return;
            }

            dbContext.Posts.Remove(reply!);
            await dbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.RemoveReply: Error removing reply with id {ReplyId}", replyId);
            throw;
        }
    }

    public async Task<int> SharePost(Post post, int sharedPostId)
    {
        logger.LogDebug("PostsRepository.SharePost: Sharing post {@Post} with id {SharedPostId}", post, sharedPostId);
        try
        {
            post.ChildPostId = sharedPostId;
            await dbContext.Posts.AddAsync(post);
            await dbContext.SaveChangesAsync();
            return post.Id;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.SharePost: Error sharing post {@Post} with id {SharedPostId}", post, sharedPostId);
            throw;
        }
    }
}