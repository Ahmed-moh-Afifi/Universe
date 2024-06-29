using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class PostsController(IPostsRepository postsRepository, IPostReactionsRepository reactionsRepository, ILogger<PostsController> logger) : ControllerBase
{
    [HttpGet]
    [Route("{userId}")]
    public async Task<ActionResult<IEnumerable<Post>>> GetPosts(string userId)
    {
        logger.LogDebug("PostsController.GetPosts: Getting posts for user with id {UserId}", userId);
        return Ok(await postsRepository.GetPosts(userId));
    }

    [HttpGet]
    [Route("replies/{postId}")]
    public async Task<ActionResult<IEnumerable<Post>>> GetReplies(int postId)
    {
        logger.LogDebug("PostsController.GetReplies: Getting replies for post with id {PostId}", postId);
        return Ok(await postsRepository.GetReplies(postId));
    }

    [HttpPost]
    [Route("")]
    public async Task<ActionResult<int>> AddPost(Post post)
    {
        logger.LogDebug("PostsController.AddPost: Adding post {@Post}", post);
        return Ok(await postsRepository.AddPost(post));
    }

    [HttpPost]
    [Route("replies/")]
    public async Task<ActionResult<int>> AddReply(Post reply, int postId)
    {
        logger.LogDebug("PostsController.AddReply: Adding reply {@Reply} to post with id {PostId}", reply, postId);
        return Ok(await postsRepository.AddReply(reply, postId));
    }

    [HttpDelete]
    [Route("{postId}")]
    public async Task<ActionResult> RemovePost(int postId)
    {
        logger.LogDebug("PostsController.RemovePost: Removing post with id {PostId}", postId);
        await postsRepository.RemovePost(postId);
        return Ok();
    }

    [HttpDelete]
    [Route("replies/{replyId}")]
    public async Task<ActionResult> RemoveReply(int replyId)
    {
        logger.LogDebug("PostsController.RemoveReply: Removing reply with id {ReplyId}", replyId);
        await postsRepository.RemoveReply(replyId);
        return Ok();
    }

    [HttpPost]
    [Route("share/{sharedPostId}")]
    public async Task<ActionResult<int>> SharePost(Post post, int sharedPostId)
    {
        logger.LogDebug("PostsController.SharePost: Sharing post {@Post} with post with id {SharedPostId}", post, sharedPostId);
        return Ok(await postsRepository.SharePost(post, sharedPostId));
    }

    [HttpGet]
    [Route("count/{userId}")]
    public async Task<ActionResult<int>> GetPostsCount(string userId)
    {
        logger.LogDebug("PostsController.GetPostsCount: Getting posts count for user with id {UserId}", userId);
        return Ok(await postsRepository.GetPostsCount(userId));
    }

    [HttpGet]
    [Route("reactions/{postId}")]
    public async Task<ActionResult<IEnumerable<PostReaction>>> GetReactions(int postId)
    {
        logger.LogDebug("ReactionsController.GetReactions: Getting reactions for post with id: {postId}", postId);
        return Ok(await reactionsRepository.GetReactions(postId));
    }

    [HttpGet]
    [Route("reactions/count/{postId}")]
    public async Task<ActionResult<int>> GetReactionsCount(int postId)
    {
        logger.LogDebug("ReactionsController.GetReactionsCount: Getting reactions count for post with id: {postId}", postId);
        return Ok(await reactionsRepository.GetReactionsCount(postId));
    }

    [HttpPost]
    [Route("reactions/")]
    public async Task<ActionResult<int>> AddReaction(PostReaction reaction)
    {
        logger.LogDebug("ReactionsController.AddReaction: Adding reaction {@Reaction}", reaction);
        return Ok(await reactionsRepository.AddReaction(reaction));
    }

    [HttpDelete]
    [Route("reactions/{reactionId}")]
    public async Task<ActionResult> RemoveReaction(int reactionId)
    {
        logger.LogDebug("ReactionsController.RemoveReaction: Removing reaction with id: {reactionId}", reactionId);
        await reactionsRepository.RemoveReaction(reactionId);
        return Ok();
    }
}