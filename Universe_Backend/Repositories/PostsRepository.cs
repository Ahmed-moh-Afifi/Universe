using Microsoft.EntityFrameworkCore;
using UniverseBackend.Data;

namespace UniverseBackend.Repositories;

public class PostsRepository(ApplicationDbContext dbContext, ILogger<PostsRepository> logger) : IPostsRepository
{
    public async Task<int> AddPost(Post post)
    {
        await dbContext.Set<Post>().AddAsync(post);
        await dbContext.SaveChangesAsync();
        return post.ID;
    }

    public async Task RemovePost(int postId)
    {
        var post = await dbContext.Set<Post>().FindAsync(postId);
        if (post == null)
        {
            // throw NotFoundException().
        }

        dbContext.Set<Post>().Remove(post!);
        await dbContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<Post>> GetPosts(int userId)
    {
        var posts = await dbContext.Set<Post>().Where(p => p.AuthorID == userId).ToListAsync();
        return posts;
    }

    public async Task<IEnumerable<Post>> GetReplies(int postId)
    {
        var replies = await dbContext.Set<Post>().Where(p => p.ReplyToPost == postId).ToListAsync();
        return replies;
    }

    public async Task<int> AddReply(Post reply)
    {
        await dbContext.Set<Post>().AddAsync(reply);
        await dbContext.SaveChangesAsync();
        return reply.ID;
    }

    public async Task RemoveReply(int replyId)
    {
        var reply = await dbContext.Set<Post>().FindAsync(replyId);
        if (reply == null)
        {
            // throw NotFountException().
        }

        dbContext.Set<Post>().Remove(reply!);
        await dbContext.SaveChangesAsync();
    }

    public async Task<int> SharePost(Post post, int sharedPostId)
    {
        post.ChildPostID = sharedPostId;
        return await AddPost(post);
    }
}