using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public class PostsRepository(ApplicationDbContext dbContext, ILogger<PostsRepository> logger) : IPostsRepository
{
    public async Task<int> AddPost(PostDTO post)
    {
        logger.LogDebug("PostsRepository.AddPost: Adding post {@Post}", post);
        try
        {
            post.Id = 0;
            await dbContext.Posts.AddAsync(post.ToModel());
            await dbContext.SaveChangesAsync();
            return post.Id;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.AddPost: Error adding post {@Post}", post);
            throw;
        }
    }

    public async Task<PostDTO> UpdatePost(PostDTO post)
    {
        logger.LogDebug("PostsRepository.UpdatePost: Updating post {@Post}", post);
        try
        {
            var existingPost = dbContext.Posts.Where(p => p.Id == post.Id).Include(p => p.Author).Single();
            if (existingPost == null)
            {
                // throw new NotFoundException("Post not found");
            }

            var updated = dbContext.Posts.Update(existingPost!.UpdateFromDTO(post));
            await dbContext.SaveChangesAsync();

            return updated.Entity.ToDTO();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.UpdatePost: Error updating post {@Post}", post);
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

    public IEnumerable<PostDTO> GetPosts(string userId, string callerId, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("PostsRepository.GetPosts: Getting posts for user with id {UserId}", userId);
        try
        {
            IEnumerable<PostDTO> posts;
            if (lastDate == null || lastId == null)
            {
                logger.LogDebug("PostsRepository.GetPosts: Getting first 10 posts");
                posts = dbContext.Posts
                    .Where(p => p.AuthorId == userId && p.ReplyToPost == -1)
                    .OrderBy(p => p.PublishDate)
                    .ThenBy(p => p.Id)
                    .Include(p => p.Author)
                    .Select(p => PostDTO.FromPost(p, p.Reactions.Any(r => r.UserId == callerId), p.Reactions.Where(r => r.UserId == callerId).Select(r => r.ToDTO()).FirstOrDefault()))
                    .Take(10);
            }
            else
            {
                logger.LogDebug("PostsRepository.GetPosts: Getting posts after date {LastDate} and id {LastId}", lastDate, lastId);
                posts = dbContext.Posts
                    .Where(p => p.AuthorId == userId)
                    .OrderBy(p => p.PublishDate)
                    .ThenBy(p => p.Id)
                    .Where(p => p.PublishDate > lastDate || (p.PublishDate == lastDate && p.Id > lastId))
                    .Include(p => p.Author)
                    .Select(p => PostDTO.FromPost(p, p.Reactions.Any(r => r.UserId == callerId), p.Reactions.Where(r => r.UserId == callerId).Select(r => r.ToDTO()).FirstOrDefault()))
                    .Take(10);
            }

            return posts;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.GetPosts: Error getting posts for user with id {UserId}", userId);
            throw;
        }
    }

    public IEnumerable<PostDTO> GetReplies(int postId, string callerId, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("PostsRepository.GetReplies: Getting replies for post with id {PostId}", postId);
        try
        {
            IEnumerable<PostDTO> replies;
            if (lastDate == null || lastId == null)
            {
                logger.LogDebug("PostsRepository.GetReplies: Getting first 10 replies");
                replies = dbContext.Posts
                    .Where(p => p.ReplyToPost == postId)
                    .OrderBy(p => p.PublishDate)
                    .ThenBy(p => p.Id)
                    .Include(p => p.Author)
                    .Select(p => PostDTO.FromPost(p, p.Reactions.Any(r => r.UserId == callerId), p.Reactions.Where(r => r.UserId == callerId).Select(r => r.ToDTO()).FirstOrDefault()))
                    .Take(10);
            }
            else
            {
                logger.LogDebug("PostsRepository.GetReplies: Getting replies after date {LastDate} and id {LastId}", lastDate, lastId);
                replies = dbContext.Posts
                    .Where(p => p.ReplyToPost == postId)
                    .OrderBy(p => p.PublishDate)
                    .ThenBy(p => p.Id)
                    .Where(p => p.PublishDate > lastDate || (p.PublishDate == lastDate && p.Id > lastId))
                    .Include(p => p.Author)
                    .Select(p => PostDTO.FromPost(p, p.Reactions.Any(r => r.UserId == callerId), p.Reactions.Where(r => r.UserId == callerId).Select(r => r.ToDTO()).FirstOrDefault()))
                    .Take(10);
            }

            return replies;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.GetReplies: Error getting replies for post with id {PostId}", postId);
            throw;
        }
    }

    public async Task<int> AddReply(PostDTO reply, int postId)
    {
        logger.LogDebug("PostsRepository.AddReply: Adding reply {@Reply} to post with id {PostId}", reply, postId);
        try
        {
            reply.Id = 0;
            reply.ReplyToPost = postId;
            await dbContext.Posts.AddAsync(reply.ToModel());
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

    public async Task<int> SharePost(PostDTO post, int sharedPostId)
    {
        logger.LogDebug("PostsRepository.SharePost: Sharing post {@Post} with id {SharedPostId}", post, sharedPostId);
        try
        {
            post.ChildPostId = sharedPostId;
            await dbContext.Posts.AddAsync(post.ToModel());
            await dbContext.SaveChangesAsync();
            return post.Id;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.SharePost: Error sharing post {@Post} with id {SharedPostId}", post, sharedPostId);
            throw;
        }
    }

    public async Task<int> GetPostsCount(string userId)
    {
        logger.LogDebug("PostsRepository.GetPostsCount: Getting posts count for user with id {UserId}", userId);
        try
        {
            var count = await dbContext.Posts.Where(p => p.AuthorId == userId).CountAsync();
            return count;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.GetPostsCount: Error getting posts count for user with id {UserId}", userId);
            throw;
        }
    }

    public IEnumerable<PostDTO> GetFollowingPosts(string userId, string callerId, DateTime? lastDate, int? lastId)
    {
        logger.LogDebug("PostsRepository.GetFollowingPosts: Getting posts for user with id {UserId}", userId);
        try
        {
            IEnumerable<PostDTO> posts;
            if (lastDate == null || lastId == null)
            {
                logger.LogDebug("PostsRepository.GetFollowingPosts: Getting first 10 posts");
                posts = dbContext.Posts
                    .Where(p => dbContext.Users.Where(u => u.Id == userId).SelectMany(u => u.Following).Select(u => u.Id).Contains(p.AuthorId))
                    .OrderBy(p => p.PublishDate)
                    .ThenBy(p => p.Id)
                    .Include(p => p.Author)
                    .Select(p => PostDTO.FromPost(p, p.Reactions.Any(r => r.UserId == callerId), p.Reactions.Where(r => r.UserId == callerId).Select(r => r.ToDTO()).FirstOrDefault()))
                    .Take(10);
            }
            else
            {
                logger.LogDebug("PostsRepository.GetFollowingPosts: Getting posts after date {LastDate} and id {LastId}", lastDate, lastId);
                posts = dbContext.Posts
                    .Where(p => dbContext.Users.Where(u => u.Id == userId).SelectMany(u => u.Following).Select(u => u.Id).Contains(p.AuthorId))
                    .OrderBy(p => p.PublishDate)
                    .ThenBy(p => p.Id)
                    .Where(p => p.PublishDate > lastDate || (p.PublishDate == lastDate && p.Id > lastId))
                    .Include(p => p.Author)
                    .Select(p => PostDTO.FromPost(p, p.Reactions.Any(r => r.UserId == callerId), p.Reactions.Where(r => r.UserId == callerId).Select(r => r.ToDTO()).FirstOrDefault()))
                    .Take(10);
            }

            return posts;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.GetFollowingPosts: Error getting posts for user with id {UserId}", userId);
            throw;
        }
    }

    public async Task<UserDTO> GetPostAuthor(int postId)
    {
        logger.LogDebug("PostsRepository.GetPostAuthor: Getting author of post with id {postId}", postId);
        try
        {
            var author = await dbContext.Posts.Where(p => p.Id == postId)
                .Select(p => p.Author)
                .Select(u => u!.ToDTO())
                .FirstOrDefaultAsync() ??
                throw new ArgumentException("Author for this post not found. This probably means that the post is not found.");

            return author;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "PostsRepository.GetPostAuthor: Error getting author of post with id {postId}", postId);
            throw;
        }
    }
}