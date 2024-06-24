using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Repositories;

public class PostsRepository(ApplicationDbContext dbContext, ILogger<PostsRepository> logger) : IPostsRepository
{
    public async Task<int> AddPost(Post post)
    {
        await dbContext.Set<Post>().AddAsync(post);
        await dbContext.SaveChangesAsync();
        return post.Id;
    }

    public async Task RemovePost(int postId)
    {
        var post = await dbContext.Posts.FindAsync(postId);
        if (post == null)
        {
            // throw NotFoundException().
        }

        dbContext.Posts.Remove(post!);
        await dbContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<Post>> GetPosts(string userId)
    {
        var posts = await dbContext.Posts.Where(p => p.AuthorId == userId).ToListAsync();
        return posts;
    }

    public async Task<IEnumerable<Post>> GetReplies(int postId)
    {
        var replies = await dbContext.Posts.Where(p => p.ReplyToPost == postId).ToListAsync();
        return replies;
    }

    public async Task<int> AddReply(Post reply)
    {
        await dbContext.Posts.AddAsync(reply);
        await dbContext.SaveChangesAsync();
        return reply.Id;
    }

    public async Task RemoveReply(int replyId)
    {
        var reply = await dbContext.Set<Post>().FindAsync(replyId);
        if (reply == null)
        {
            // throw NotFountException().
        }

        dbContext.Posts.Remove(reply!);
        await dbContext.SaveChangesAsync();
    }

    public async Task<int> SharePost(Post post, int sharedPostId)
    {
        post.ChildPostId = sharedPostId;
        return await AddPost(post);
    }
}