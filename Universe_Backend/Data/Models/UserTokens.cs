namespace Universe_Backend.Data.Models;

public class UserTokens
{
    public required string AccessToken { get; set; }
    public required string RefreshToken { get; set; }
}
