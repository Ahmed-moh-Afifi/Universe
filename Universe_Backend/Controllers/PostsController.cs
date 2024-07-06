using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class PostsController(IPostsRepository postsRepository, IPostReactionsRepository reactionsRepository, IAuthorizationService authorizationService, ILogger<PostsController> logger) : ControllerBase
{
    [HttpGet]
    [Route("{userId}")]
    public async Task<ActionResult<IEnumerable<PostDTO>>> GetPosts(string userId)
    {
        logger.LogDebug("PostsController.GetPosts: Getting posts for user with id {UserId}", userId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("PostsController.GetPosts: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(await postsRepository.GetPosts(userId));
    }

    [HttpGet]
    [Route("{userId}/{postId}/replies")]
    public async Task<ActionResult<IEnumerable<PostDTO>>> GetReplies(string userId, int postId)
    {
        logger.LogDebug("PostsController.GetReplies: Getting replies for post with id {PostId}", postId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("PostsController.GetReplies: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(await postsRepository.GetReplies(postId));
    }

    [HttpPost]
    [Route("")]
    [Authorize()]
    public async Task<ActionResult<int>> AddPost([FromBody] PostDTO post)
    {
        logger.LogDebug("PostsController.AddPost: Adding post {@Post}", post);
        if (post.AuthorId != User.FindFirstValue("uid"))
        {
            logger.LogWarning("PostsController.AddPost: User with id {UserId} tried to add post with author id {AuthorId}", User.FindFirstValue("uid"), post.AuthorId);
            return Unauthorized();
        }
        return Ok(await postsRepository.AddPost(post));
    }

    [HttpPost]
    [Route("{userId}/{postId}/replies/")]
    [Authorize()]
    public async Task<ActionResult<int>> AddReply([FromBody] PostDTO reply, int postId, string userId)
    {
        logger.LogDebug("PostsController.AddReply: Adding reply {@Reply} to post with id {PostId}", reply, postId);
        if (reply.AuthorId != User.FindFirstValue("uid"))
        {
            logger.LogWarning("PostsController.AddReply: User with id {UserId} tried to add reply with author id {AuthorId}", User.FindFirstValue("uid"), reply.AuthorId);
            return Unauthorized();
        }

        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("PostsController.AddReply: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(await postsRepository.AddReply(reply, postId));
    }

    [HttpPut]
    [Route("{userId}/{postId}")]
    public async Task<ActionResult<PostDTO>> UpdatePost([FromBody] PostDTO post, string userId, int postId)
    {
        logger.LogDebug("PostsController.UpdatePost: Updating post {@Post}", post);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(post.Id.ToString(), typeof(Post)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("PostsController.UpdatePost: User with id {UserId} is not the owner of post with id {PostId}", User.FindFirstValue("uid"), post.Id);
            return Unauthorized();
        }

        return Ok(await postsRepository.UpdatePost(post));
    }

    [HttpDelete]
    [Route("{postId}")]
    public async Task<ActionResult> DeletePost(int postId)
    {
        logger.LogDebug("PostsController.RemovePost: Removing post with id {PostId}", postId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(postId.ToString(), typeof(Post)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("PostsController.RemovePost: User with id {UserId} is not the owner of post with id {PostId}", User.FindFirstValue("uid"), postId);
            return Unauthorized();
        }

        await postsRepository.RemovePost(postId);
        return Ok();
    }

    [HttpDelete]
    [Route("replies/{replyId}")]
    public async Task<ActionResult> DeleteReply(int replyId)
    {
        logger.LogDebug("PostsController.RemoveReply: Removing reply with id {ReplyId}", replyId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(replyId.ToString(), typeof(Post)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("PostsController.RemoveReply: User with id {UserId} is not the owner of reply with id {ReplyId}", User.FindFirstValue("uid"), replyId);
            return Unauthorized();
        }

        await postsRepository.RemoveReply(replyId);
        return Ok();
    }

    [HttpPost]
    [Route("share/{sharedPostId}")]
    [Authorize()]
    public async Task<ActionResult<int>> SharePost([FromBody] PostDTO post, int sharedPostId)
    {
        logger.LogDebug("PostsController.SharePost: Sharing post {@Post} with post with id {SharedPostId}", post, sharedPostId);
        if (post.AuthorId != User.FindFirstValue("uid"))
        {
            logger.LogWarning("PostsController.SharePost: User with id {UserId} tried to share post with author id {AuthorId}", User.FindFirstValue("uid"), post.AuthorId);
            return Unauthorized();
        }

        return Ok(await postsRepository.SharePost(post, sharedPostId));
    }

    [HttpGet]
    [Route("{userId}/count")]
    [Authorize()]
    public async Task<ActionResult<int>> GetPostsCount(string userId)
    {
        logger.LogDebug("PostsController.GetPostsCount: Getting posts count for user with id {UserId}", userId);
        return Ok(await postsRepository.GetPostsCount(userId));
    }

    [HttpGet]
    [Route("{userId}/{postId}/reactions")]
    public async Task<ActionResult<IEnumerable<PostReactionDTO>>> GetReactions(string userId, int postId)
    {
        logger.LogDebug("ReactionsController.GetReactions: Getting reactions for post with id: {postId}", postId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("ReactionsController.GetReactions: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(await reactionsRepository.GetReactions(postId));
    }

    [HttpGet]
    [Route("{userId}/{postId}/reactions/count")]
    public async Task<ActionResult<int>> GetReactionsCount(int userId, int postId)
    {
        logger.LogDebug("ReactionsController.GetReactionsCount: Getting reactions count for post with id: {postId}", postId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("ReactionsController.GetReactionsCount: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(await reactionsRepository.GetReactionsCount(postId));
    }

    [HttpPost]
    [Route("{userId}/{postId}/reactions")]
    [Authorize()]
    public async Task<ActionResult<int>> AddReaction([FromBody] PostReactionDTO reaction, string userId, int postId)
    {
        logger.LogDebug("ReactionsController.AddReaction: Adding reaction {@Reaction}", reaction);
        if (reaction.UserId != User.FindFirstValue("uid"))
        {
            logger.LogWarning("ReactionsController.AddReaction: User with id {UserId} tried to add reaction with user id {ReactionUserId}", User.FindFirstValue("uid"), reaction.UserId);
            return Unauthorized();
        }

        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("ReactionsController.AddReaction: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(await reactionsRepository.AddReaction(reaction));
    }

    [HttpDelete]
    [Route("reactions/{reactionId}")]
    public async Task<ActionResult> RemoveReaction(int reactionId)
    {
        logger.LogDebug("ReactionsController.RemoveReaction: Removing reaction with id: {reactionId}", reactionId);
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(reactionId.ToString(), typeof(PostReaction)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("ReactionsController.RemoveReaction: User with id {UserId} is not the owner of reaction with id {ReactionId}", User.FindFirstValue("uid"), reactionId);
            return Unauthorized();
        }

        await reactionsRepository.RemoveReaction(reactionId);
        return Ok();
    }

    [HttpGet]
    [Route("following/")]
    [Authorize()]
    public async Task<ActionResult<IEnumerable<PostDTO>>?> GetFollowingPosts()
    {
        logger.LogDebug("PostsController.GetFollowingPosts: Getting posts of users followed by user with id: {userId}", User.FindFirstValue("uid"));
        return Ok(await postsRepository.GetFollowingPosts(User.FindFirstValue("uid")!));
    }
}