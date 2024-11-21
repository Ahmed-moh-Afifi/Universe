using Microsoft.AspNetCore.Authorization;

namespace Universe_Backend.Services;

public class IsFollowerRequirement(bool isFollowerRequirementEnabled) : IAuthorizationRequirement
{
    public bool IsFollowerRequirementEnabled { get; set; } = isFollowerRequirementEnabled;
}
