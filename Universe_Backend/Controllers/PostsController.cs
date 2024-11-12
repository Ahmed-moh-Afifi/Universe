using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using NotificationService.Models;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;
using Universe_Backend.Hubs;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("{userId}/[controller]")]
public class PostsController(IPostsRepository postsRepository, IPostReactionsRepository reactionsRepository, IUsersRepository usersRepository, IAuthorizationService authorizationService, NotificationService.NotificationService notificationService, ILogger<PostsController> logger) : ControllerBase
{
    [HttpGet]
    [Route("")]
    public async Task<ActionResult<IEnumerable<PostDTO>>> GetPosts(string userId)
    {
        logger.LogDebug("PostsController.GetPosts: Getting posts for user with id {UserId}", userId);
        // Validate route parameters.
        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("PostsController.GetPosts: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(postsRepository.GetPosts(userId, User.FindFirstValue("uid")!, null, null));
    }

    [HttpGet]
    [Route("{postId}/Replies")]
    public async Task<ActionResult<IEnumerable<PostDTO>>> GetReplies(string userId, int postId, DateTime lastDate, int lastId)
    {
        logger.LogDebug("PostsController.GetReplies: Getting replies for post with id {PostId}", postId);
        // Validate route parameters.
        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("PostsController.GetReplies: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(postsRepository.GetReplies(postId, User.FindFirstValue("uid")!, lastDate, lastId));
    }

    [HttpPost]
    [Route("")]
    [Authorize()]
    public async Task<ActionResult<int>> AddPost([FromBody] PostDTO post, string userId)
    {
        logger.LogDebug("PostsController.AddPost: Adding post {@Post}", post);
        // Validate route parameters.
        if (post.Author.Id != User.FindFirstValue("uid"))
        {
            logger.LogWarning("PostsController.AddPost: User with id {UserId} tried to add post with author id {AuthorId}", User.FindFirstValue("uid"), post.Author.Id);
            return Unauthorized();
        }

        var author = await usersRepository.GetUser(post.Author.Id);

        var addedPost = await postsRepository.AddPost(post);

        var notification = new SingleUserNotification()
        {
            Title = "New Post",
            Body = $"{author.UserName} has posted something new!",
            Recipient = post.Author.Id,
            Sender = post.Author.Id,
            Platform = Platform.Android,
            RecipientType = RecipientType.Topic
        };
        logger.LogDebug("PostsController.AddPost: Sending notification {@Notification}", notification);
        await notificationService.SendNotificationAsync(notification);

        return Ok(addedPost);
    }

    [HttpPost]
    [Route("{postId}/Replies/")]
    [Authorize()]
    public async Task<ActionResult<int>> AddReply([FromBody] PostDTO reply, int postId, string userId)
    {
        logger.LogDebug("PostsController.AddReply: Adding reply {@Reply} to post with id {PostId}", reply, postId);
        // Validate route parameters.
        if (reply.Author.Id != User.FindFirstValue("uid"))
        {
            logger.LogWarning("PostsController.AddReply: User with id {UserId} tried to add reply with author id {AuthorId}", User.FindFirstValue("uid"), reply.Author.Id);
            return Unauthorized();
        }

        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("PostsController.AddReply: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        var addedReply = await postsRepository.AddReply(reply, postId);

        var postAuthor = await postsRepository.GetPostAuthor(postId);

        var postAuthorNotificationToken = await usersRepository.GetNotificationTokens(postAuthor.Id);

        var authorNotification = new MultipleUserNotification()
        {
            Title = "New Reply",
            Body = $"{reply.Author.UserName} replied to your post.",
            Platform = Platform.Android,
            Recipients = postAuthorNotificationToken.Select(nt => nt.Token).ToList(),
            Sender = reply.Author.Id,
        };
        await notificationService.SendNotificationAsync(authorNotification);

        var audienceNotification = new SingleUserNotification()
        {
            Title = "New Reply",
            Body = $"{reply.Author.UserName} replied to {postAuthor.UserName}'s post.",
            Platform= Platform.Android,
            RecipientType = RecipientType.Topic,
            Recipient = reply.ReplyToPost.ToString()!,
            Sender = reply.Author.Id,
        };
        await notificationService.SendNotificationAsync(audienceNotification);

        return Ok(addedReply);
    }

    [HttpPut]
    [Route("{postId}")]
    public async Task<ActionResult<PostDTO>> UpdatePost([FromBody] PostDTO post, string userId, int postId)
    {
        logger.LogDebug("PostsController.UpdatePost: Updating post {@Post}", post);
        // Validate route parameters.
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
    public async Task<ActionResult> DeletePost(int postId, string userId)
    {
        logger.LogDebug("PostsController.RemovePost: Removing post with id {PostId}", postId);
        // Validate route parameters.
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
    [Route("{postId}/Replies/{replyId}")]
    public async Task<ActionResult> DeleteReply(int replyId, string userId, int postId)
    {
        logger.LogDebug("PostsController.RemoveReply: Removing reply with id {ReplyId}", replyId);
        // Validate route parameters.
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
    [Route("Share/{sharedPostId}")]
    [Authorize()]
    public async Task<ActionResult<int>> SharePost([FromBody] PostDTO post, int sharedPostId, string userId)
    {
        logger.LogDebug("PostsController.SharePost: Sharing post {@Post} with post with id {SharedPostId}", post, sharedPostId);
        // Validate route parameters.
        if (post.Author.Id != User.FindFirstValue("uid"))
        {
            logger.LogWarning("PostsController.SharePost: User with id {UserId} tried to share post with author id {AuthorId}", User.FindFirstValue("uid"), post.Author.Id);
            return Unauthorized();
        }

        var newPostId = await postsRepository.SharePost(post, sharedPostId);

        return Ok(newPostId);
    }

    [HttpGet]
    [Route("Count")]
    [Authorize()]
    public async Task<ActionResult<int>> GetPostsCount(string userId)
    {
        logger.LogDebug("PostsController.GetPostsCount: Getting posts count for user with id {UserId}", userId);
        // Validate route parameters.
        return Ok(await postsRepository.GetPostsCount(userId));
    }

    [HttpGet]
    [Route("{postId}/Reactions")]
    public async Task<ActionResult<IEnumerable<PostFullReactionDTO>>> GetReactions(string userId, int postId, DateTime lastDate, int lastId)
    {
        logger.LogDebug("ReactionsController.GetReactions: Getting reactions for post with id: {postId}", postId);
        // Validate route parameters.
        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("ReactionsController.GetReactions: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(await reactionsRepository.GetReactions(postId, lastDate, lastId));
    }

    [HttpGet]
    [Route("{postId}/Reactions/Count")]
    public async Task<ActionResult<int>> GetReactionsCount(int userId, int postId)
    {
        logger.LogDebug("ReactionsController.GetReactionsCount: Getting reactions count for post with id: {postId}", postId);
        // Validate route parameters.
        var authorizationResult = await authorizationService.AuthorizeAsync(User, userId, "IsFollower");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("ReactionsController.GetReactionsCount: User with id {UserId} is not a follower of user with id {FollowedId}", User.FindFirstValue("uid"), userId);
            return Unauthorized();
        }

        return Ok(await reactionsRepository.GetReactionsCount(postId));
    }

    [HttpPost]
    [Route("{postId}/Reactions")]
    [Authorize()]
    public async Task<ActionResult<int>> AddReaction([FromBody] PostReactionDTO reaction, string userId, int postId, [FromServices] IHubContext<ReactionsCountHub> hubContext)
    {
        logger.LogDebug("ReactionsController.AddReaction: Adding reaction {@Reaction}", reaction);
        // Validate route parameters.
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

        var reactionId = await reactionsRepository.AddReaction(reaction);
        reaction.Id = reactionId;
        logger.LogDebug($"ReactionsController.AddReaction: Added reaction {reactionId}");

        logger.LogDebug("ReactionsController.AddReaction: Sending notification to subscribers");
        await hubContext.Clients.Group(postId.ToString()).SendAsync("UpdateReactionsCount", 1, User.FindFirstValue("uid")!, reaction);

        return Ok(reactionId);
    }

    [HttpDelete]
    [Route("{postId}/Reactions/{reactionId}")]
    public async Task<ActionResult> RemoveReaction(int reactionId, string userId, int postId, [FromServices] IHubContext<ReactionsCountHub> hubContext)
    {
        logger.LogDebug("ReactionsController.RemoveReaction: Removing reaction with id: {reactionId}", reactionId);
        // Validate route parameters.
        var authorizationResult = await authorizationService.AuthorizeAsync(User, new KeyValuePair<string, Type>(reactionId.ToString(), typeof(PostReaction)), "IsOwner");
        if (!authorizationResult.Succeeded)
        {
            logger.LogWarning("ReactionsController.RemoveReaction: User with id {UserId} is not the owner of reaction with id {ReactionId}", User.FindFirstValue("uid"), reactionId);
            return Unauthorized();
        }

        await reactionsRepository.RemoveReaction(reactionId);

        await hubContext.Clients.Group(postId.ToString()).SendAsync("UpdateReactionsCount", -1, User.FindFirstValue("uid")!);

        return Ok();
    }

    [HttpGet]
    [Route("Following/")]
    [Authorize()]
    public ActionResult<IEnumerable<PostDTO>>? GetFollowingPosts(string userId, DateTime lastDate, int lastId)
    {
        logger.LogDebug("PostsController.GetFollowingPosts: Getting posts of users followed by user with id: {userId}", User.FindFirstValue("uid"));
        // Validate route parameters.
        return Ok(postsRepository.GetFollowingPosts(User.FindFirstValue("uid")!, User.FindFirstValue("uid")!, lastDate, lastId));
    }

    [HttpGet]
    [Route("{postId}/Reactions/{reactorId}")]
    public async Task<ActionResult<PostReactionDTO>> IsPostReactedToByUser(int postId, string reactorId)
    {
        logger.LogDebug("ReactionsController.isPostReactedToByUser: Checking if post with id {postId} is reacted to by user with id {userId}", postId, reactorId);
        // Validate route parameters.
        return Ok(await reactionsRepository.IsPostReactedToByUser(postId, reactorId));
    }
}