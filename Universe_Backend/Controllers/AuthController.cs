using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;
using Universe_Backend.Services;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class AuthController(UserManager<User> userManager, TokenService tokenService, ApplicationDbContext context, IConfiguration configuration, ILogger<AuthController> logger) : ControllerBase
{
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterModel model)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        logger.LogDebug("AuthController -> register: creating IdentityUser from userName and email.");
        var user = Data.Models.User.FromRegisterModel(model);

        logger.LogDebug("AuthController -> register: creating user.");
        var result = await userManager.CreateAsync(user, model.Password);

        if (!result.Succeeded)
            return BadRequest(result.Errors);

        return Ok(new { Message = "User registered successfully" });
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginModel model)
    {
        logger.LogDebug("AuthController -> login: finding user");
        var user = await userManager.FindByNameAsync(model.Username);
        logger.LogDebug("AuthController -> login: checking password");
        if (user == null || !await userManager.CheckPasswordAsync(user, model.Password))
            return Unauthorized();

        logger.LogDebug("AuthController -> login: generating claims");
        var claims = new[]
        {
            // new Claim(JwtRegisteredClaimNames.Sub, user.UserName!),
            new Claim("uid", user.Id),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        logger.LogDebug("AuthController -> login: generating access token and refresh token");
        var accessToken = tokenService.GenerateAccessToken(claims);
        var refreshToken = tokenService.GenerateRefreshToken();

        var refreshTokenEntity = new RefreshToken
        {
            Token = refreshToken,
            UserId = user.Id,
            ExpiryDate = DateTime.UtcNow.AddDays(int.Parse(configuration["Jwt:RefreshTokenExpiresInDays"]!))
        };

        logger.LogDebug("AuthController -> login: saving refresh token");
        context.RefreshTokens.Add(refreshTokenEntity);

        if (model.Username == "ahmedafifi")
        {
            user.NotificationToken = "drWSaSCTQsyNAEVH29BS-_:APA91bFNJ7zbEK6F8aPZG0UE8mByWfiSbBlMq4V1hBAUBjuD-pJjCLdk0pSqjQO53PAv87I-MCNqnwPkMx9ULCwXjGYTbP1OXM5h2y7EF5NtiMuZkQrnRzoNHN8C-o4B8Ufx-eE1zcgL";
        }

        await context.SaveChangesAsync();

        return Ok(new
        {
            AccessToken = accessToken,
            RefreshToken = refreshToken
        });
    }

    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh([FromBody] TokenModel model)
    {
        logger.LogDebug("AuthController -> refresh: getting claims from expired token");
        var claims = tokenService.GetPrincipalFromExpiredToken(model.AccessToken);

        logger.LogDebug("AuthController -> refresh: getting user id from claims");
        var userId = claims.First(c => c.Type == "uid");
        // var userName = claims.First(c => c.Type == ClaimTypes.NameIdentifier);

        logger.LogDebug("AuthController -> refresh: getting saved refresh token");
        var savedRefreshToken = await context.RefreshTokens
            .FirstOrDefaultAsync(rt => rt.Token == model.RefreshToken && rt.UserId == userId!.Value);

        // savedRefreshToken = from user in userManager.Users
        //                     where user.UserName == userName.Value
        //                     join refreshToken in context.RefreshTokens on user.Id equals refreshToken.UserId
        //                     select refreshToken;



        if (savedRefreshToken == null || savedRefreshToken.ExpiryDate < DateTime.UtcNow || savedRefreshToken.IsRevoked)
            return Unauthorized();

        logger.LogDebug("AuthController -> refresh: generating new access token and refresh token");
        var newAccessToken = tokenService.GenerateAccessToken(claims);
        var newRefreshToken = tokenService.GenerateRefreshToken();

        logger.LogDebug("AuthController -> refresh: updating refresh token");
        savedRefreshToken.Token = newRefreshToken;
        savedRefreshToken.ExpiryDate = DateTime.UtcNow.AddDays(int.Parse(configuration["Jwt:RefreshTokenExpiresInDays"]!));
        await context.SaveChangesAsync();

        return Ok(new
        {
            AccessToken = newAccessToken,
            RefreshToken = newRefreshToken
        });
    }
}
