using Universe_Backend.Data.Models;

namespace Universe_Backend.Services;

public interface IAuthenticationService
{
    public Task Register(RegisterModel model);
    public Task<UserTokens> Login(LoginModel model);
    public Task<UserTokens> RefreshToken(string refreshToken);

    // public Task RevokeToken(string refreshToken);
}
