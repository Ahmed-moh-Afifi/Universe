using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data;
using Universe_Backend.Data.Models;
using Universe_Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Universe_Backend.Repositories;
using NotificationService.Models;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("[controller]")]
public class AuthController(UserManager<User> userManager, TokenService tokenService, NotificationService.NotificationService notificationService, IUsersRepository usersRepository, ApplicationDbContext context, IConfiguration configuration, ILogger<AuthController> logger) : ControllerBase
{
    [HttpPost("Register")]
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

    [HttpPost("Login")]
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

        var notificationTokens = await usersRepository.GetNotificationTokens(user.Id);

        if (notificationTokens.Any())
        {
            var notification = new MultipleUserNotification()
            {
                Recipients = notificationTokens.Select(nt => nt.Token).ToList(),
                Sender = user.Id,
                Title = "New Login",
                Body = "You have logged in from a new device.",
                Platform = Platform.Android
            };

            await notificationService.SendNotificationAsync(notification);
        }

        logger.LogDebug("AuthController -> login: saving refresh token");
        context.RefreshTokens.Add(refreshTokenEntity);

        await context.SaveChangesAsync();


        return Ok(new
        {
            AccessToken = accessToken,
            RefreshToken = refreshToken
        });
    }

    [HttpPost("Refresh")]
    public async Task<IActionResult> Refresh([FromBody] TokenModel model)
    {
        logger.LogDebug("AuthController -> refresh: getting claims from expired token");
        var claims = tokenService.GetPrincipalFromExpiredToken(model.AccessToken);

        logger.LogDebug("AuthController -> refresh: getting user id from claims");
        var userId = claims.First(c => c.Type == "uid");

        logger.LogDebug("AuthController -> refresh: getting saved refresh token");
        var savedRefreshToken = await context.RefreshTokens
            .FirstOrDefaultAsync(rt => rt.Token == model.RefreshToken && rt.UserId == userId!.Value);

        if (savedRefreshToken == null || savedRefreshToken.ExpiryDate < DateTime.UtcNow || savedRefreshToken.IsRevoked)
        {
            logger.LogDebug("Invalid refresh token. Returning unathorized...");
            logger.LogDebug((savedRefreshToken == null).ToString());
            return Unauthorized();
        }

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

    [HttpPost()]
    [Route("NotificationToken")]
    [Authorize()]
    public async Task<IActionResult> AddNotificationToken([FromBody] NotificationTokenModel model)
    {
        logger.LogDebug("AuthController -> addNotificationToken: checking if user is authorized");
        if (User.Claims.First(c => c.Type == "uid").Value != model.UserId)
            return Unauthorized();

        logger.LogDebug("AuthController -> addNotificationToken: finding user");
        var user = await userManager.FindByIdAsync(model.UserId);
        if (user == null)
            return NotFound();

        logger.LogDebug("AuthController -> addNotificationToken: checking if token already exists");
        var ntExists = await context.Users.Where(u => u.Id == model.UserId).SelectMany(u => u.NotificationTokens).AnyAsync(nt => nt.Token == model.Token);

        if (!ntExists)
        {
            logger.LogDebug("AuthController -> addNotificationToken: adding new notification token");
            user.NotificationTokens.Add(new NotificationToken()
            {
                Token = model.Token,
                UserId = model.UserId,
                Platform = model.Platform,
                CreatedAt = DateTime.UtcNow,
            });
        }

        await context.SaveChangesAsync();

        return Ok();
    }
}
