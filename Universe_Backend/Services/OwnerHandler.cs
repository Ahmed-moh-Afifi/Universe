using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Services;

public class OwnerHandler(ApplicationDbContext dbContext, ILogger<OwnerHandler> logger) : AuthorizationHandler<OwnerRequirement>
{
    protected override async Task HandleRequirementAsync(AuthorizationHandlerContext context, OwnerRequirement requirement)
    {
        logger.LogDebug("OwnerHandler invoked");
        try
        {
            if (context.Resource is HttpContext httpContext)
            {
                logger.LogDebug("OwnerHandler.HandleRequirementAsync: got HttpContext");
                var param = httpContext.Request.RouteValues.First().Value;

                if (param is Post paramPost)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: got Post");
                    var post = await dbContext.Posts.FindAsync(paramPost.Id);
                    if (post == null)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Post not found");
                        context.Fail(new AuthorizationFailureReason(this, "Post not found"));
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Post found");
                        var userId = httpContext.User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
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
                else if (param is Story paramStory)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: got Story");
                    var story = await dbContext.Stories.FindAsync(paramStory.Id);
                    if (story == null)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Story not found");
                        context.Fail(new AuthorizationFailureReason(this, "Story not found"));
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: Story found");
                        var userId = httpContext.User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
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
                else if (param is User paramUser)
                {
                    logger.LogDebug("OwnerHandler.HandleRequirementAsync: got User");
                    var user = await dbContext.Users.FindAsync(paramUser.Id);
                    if (user == null)
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: User not found");
                        context.Fail(new AuthorizationFailureReason(this, "User not found"));
                    }
                    else
                    {
                        logger.LogDebug("OwnerHandler.HandleRequirementAsync: User found");
                        var userId = httpContext.User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
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