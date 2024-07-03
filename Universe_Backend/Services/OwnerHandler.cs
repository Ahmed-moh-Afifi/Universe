using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Services;

public class OwnerHandler(ApplicationDbContext dbContext, ILogger<OwnerHandler> logger) : AuthorizationHandler<OwnerRequirement, object>
{
    protected override async Task HandleRequirementAsync(AuthorizationHandlerContext context, OwnerRequirement requirement, object resource)
    {
        logger.LogDebug("OwnerHandler invoked");
        try
        {
            if (context.Resource is HttpContext httpContext)
            {
                logger.LogDebug("OwnerHandler.HandleRequirementAsync: got HttpContext");

                if (resource is Post resourcePost)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: got Post");
                    var post = await dbContext.Posts.FindAsync(resourcePost.Id);
                    if (post == null)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Post not found");
                        context.Fail(new AuthorizationFailureReason(this, "Post not found"));
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Post found");
                        var userId = httpContext.User.FindFirstValue("uid")!;
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
                else if (resource is Story resourceStory)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: got Story");
                    var story = await dbContext.Stories.FindAsync(resourceStory.Id);
                    if (story == null)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Story not found");
                        context.Fail(new AuthorizationFailureReason(this, "Story not found"));
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Story found");
                        var userId = httpContext.User.FindFirstValue("uid")!;
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
                else if (resource is User resourceUser)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: got User");
                    var user = await dbContext.Users.FindAsync(resourceUser.Id);
                    if (user == null)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: User not found");
                        context.Fail(new AuthorizationFailureReason(this, "User not found"));
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: User found");
                        var userId = httpContext.User.FindFirstValue("uid")!;
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
            }
            else
            {
                logger.LogDebug("OwnerHandler.HandleRequirementAsync: not a HttpContext");
                context.Fail();
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "OwnerHandler.HandleRequirementAsync: An error occurred");
            context.Fail(new AuthorizationFailureReason(this, "An error occurred"));
        }
    }
}