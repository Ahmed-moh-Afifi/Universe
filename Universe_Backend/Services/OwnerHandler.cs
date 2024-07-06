using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Services;

public class OwnerHandler(ApplicationDbContext dbContext, ILogger<OwnerHandler> logger) : AuthorizationHandler<OwnerRequirement, KeyValuePair<string, Type>>
{
    protected override async Task HandleRequirementAsync(AuthorizationHandlerContext context, OwnerRequirement requirement, KeyValuePair<string, Type> resourceTypeAndId)
    {
        logger.LogDebug("OwnerHandler invoked");
        try
        {
            logger.LogDebug("OwnerHandler.HandleRequirementAsync: got HttpContext");

            if (resourceTypeAndId.Value == typeof(Post))
            {
                logger.LogDebug("OwnerHandler.HandleRequirementAsync: got Post");
                int id = int.Parse(resourceTypeAndId.Key);
                var post = await dbContext.Posts.FindAsync(id);
                if (post == null)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: Post not found");
                    context.Fail(new AuthorizationFailureReason(this, "Post not found"));
                }
                else
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: Post found");
                    var userId = context.User.FindFirstValue("uid")!;
                    if (post.AuthorId == userId)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Post author matches user");
                        context.Succeed(requirement);
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Post author does not match user");
                        context.Fail();
                    }
                }
            }
            else if (resourceTypeAndId.Value == typeof(Story))
            {
                logger.LogDebug("OwnerHandler.HandleRequirementAsync: got Story");
                int id = int.Parse(resourceTypeAndId.Key);
                var story = await dbContext.Stories.FindAsync(id);
                if (story == null)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: Story not found");
                    context.Fail(new AuthorizationFailureReason(this, "Story not found"));
                }
                else
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: Story found");
                    var userId = context.User.FindFirstValue("uid")!;
                    if (story.AuthorId == userId)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Story author matches user");
                        context.Succeed(requirement);
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Story author does not match user");
                        context.Fail();
                    }
                }
            }
            else if (resourceTypeAndId.Value == typeof(User))
            {
                logger.LogDebug("OwnerHandler.HandleRequirementAsync: got User");
                var user = await dbContext.Users.FindAsync(resourceTypeAndId.Key);
                if (user == null)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: User not found");
                    context.Fail(new AuthorizationFailureReason(this, "User not found"));
                }
                else
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: User found");
                    var userId = context.User.FindFirstValue("uid")!;
                    if (user.Id == userId)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: User matches user");
                        context.Succeed(requirement);
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: User does not match user");
                        context.Fail();
                    }
                }
            }
            else if (resourceTypeAndId.Value == typeof(PostReaction))
            {
                logger.LogDebug("OwnerHandler.HandleRequirementAsync: got PostReaction");
                int id = int.Parse(resourceTypeAndId.Key);
                var reaction = await dbContext.PostsReactions.FindAsync(id);
                if (reaction == null)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: PostReaction not found");
                    context.Fail(new AuthorizationFailureReason(this, "PostReaction not found"));
                }
                else
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: PostReaction found");
                    var userId = context.User.FindFirstValue("uid")!;
                    if (reaction.UserId == userId)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: PostReaction user matches user");
                        context.Succeed(requirement);
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: PostReaction user does not match user");
                        context.Fail();
                    }
                }
            }
            else if (resourceTypeAndId.Value == typeof(StoryReaction))
            {
                logger.LogDebug("OwnerHandler.HandleRequirementAsync: got StoryReaction");
                int id = int.Parse(resourceTypeAndId.Key);
                var reaction = await dbContext.StoriesReactions.FindAsync(id);
                if (reaction == null)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: StoryReaction not found");
                    context.Fail(new AuthorizationFailureReason(this, "StoryReaction not found"));
                }
                else
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: StoryReaction found");
                    var userId = context.User.FindFirstValue("uid")!;
                    if (reaction.UserId == userId)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: StoryReaction user matches user");
                        context.Succeed(requirement);
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: StoryReaction user does not match user");
                        context.Fail();
                    }
                }
            }
            else
            {
                logger.LogDebug("OwnerHandler.HandleRequirementAsync: unknown resource type");
                context.Fail(new AuthorizationFailureReason(this, "Unknown resource type"));

            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "OwnerHandler.HandleRequirementAsync: An error occurred");
            context.Fail(new AuthorizationFailureReason(this, "An error occurred"));
        }
    }
}