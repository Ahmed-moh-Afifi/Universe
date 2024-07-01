using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;

namespace Universe_Backend.Services;

public class IsFollowerHandler(ApplicationDbContext dbContext) : AuthorizationHandler<IsFollowerRequirement>
{
    protected override async Task HandleRequirementAsync(AuthorizationHandlerContext context, IsFollowerRequirement requirement)
    {
        var isFollower = await dbContext.Users.Where(u => u.Id == context.User.Claims.First().Value).Select(u => new { u.Id }).ContainsAsync(new { Id = (context.Resource as string)! });

    }
}
