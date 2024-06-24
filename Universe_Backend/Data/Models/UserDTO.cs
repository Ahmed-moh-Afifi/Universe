namespace Universe_Backend.Data.Models;

public class UserDTO
{
    public required string Id { get; set; }
    public required string FirstName { get; set; }
    public required string LastName { get; set; }
    // public required bool Gender { get; set; }
    // public DateTime JoinDate { get; set; } = DateTime.Now;
    // public string? PhotoUrl { get; set; } = null;
    // public bool Verified { get; set; } = false;
    // public string? Bio { get; set; }
    // public AccountState AccountState { get; set; } = AccountState.Active;
    // public DateTime? LastOnline { get; set; }
    // public required OnlineStatus OnlineStatus { get; set; } = OnlineStatus.Online;
}
