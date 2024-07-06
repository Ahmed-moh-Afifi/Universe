using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Services;

public class IsFollowerHandler(ApplicationDbContext dbContext, ILogger<IsFollowerHandler> logger) : AuthorizationHandler<IsFollowerRequirement, string>
{
    protected override async Task HandleRequirementAsync(AuthorizationHandlerContext context, IsFollowerRequirement requirement, string userId)
    {
        logger.LogDebug("IsFollowerHandler: Checking if user is a follower of the requested user");
        try
        {
            logger.LogDebug("IsFollowerHandler: Requested user id is {UserId}", userId);
            string currentUserId = context.User.FindFirstValue("uid")!;
            logger.LogDebug("IsFollowerHandler: Current user id is {CurrentUserId}", currentUserId);

            var isPublic = await dbContext.Users
                .Where(u => u.Id == userId)
                .Select(u => u.AccountPrivacy)
                .SingleAsync() == AccountPrivacy.Public;

            if (isPublic || currentUserId == userId)
            {
                logger.LogDebug("IsFollowerHandler: User {UserId} is public or the same as the current user", userId);
                context.Succeed(requirement);
                return;
            }

            var isFollower = await dbContext.Users
                .Where(u => u.Id == currentUserId)
                .SelectMany(u => u.Following)
                .Select(u => u.Id)
                .ContainsAsync(userId);

            if (isFollower)
            {
                context.Succeed(requirement);
                return;
            }
            else
            {
                logger.LogWarning("IsFollowerHandler: User {UserId} is not a follower of user {FollowedId}", currentUserId, userId);
                context.Fail();
                return;
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "IsFollowerHandler: An error occurred while checking if user is a follower of the requested user");
            context.Fail(new AuthorizationFailureReason(this, "An error occurred while checking if user is a follower of the requested user"));
        }
    }
}
