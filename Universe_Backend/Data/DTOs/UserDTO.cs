using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs;

public class UserDTO
{
    public required string Id { get; set; }
    public required string FirstName { get; set; }
    public required string LastName { get; set; }
    public required string UserName { get; set; }
    public required string Email { get; set; }
    public required bool Gender { get; set; }
    public DateTime JoinDate { get; set; } = DateTime.Now;
    public string? PhotoUrl { get; set; } = null;
    public bool Verified { get; set; } = false;
    public string? Bio { get; set; }
    public required AccountState AccountState { get; set; }
    public required AccountPrivacy AccountPrivacy { get; set; }
    public DateTime? LastOnline { get; set; }
    public int OnlineSesions { get; set; }

    public User ToModel()
    {
        return new User
        {
            Id = Id,
            FirstName = FirstName,
            LastName = LastName,
            UserName = UserName,
            Email = Email,
            Gender = Gender,
            JoinDate = JoinDate,
            PhotoUrl = PhotoUrl,
            Verified = Verified,
            Bio = Bio,
            AccountState = AccountState,
            LastOnline = LastOnline,
            OnlineSessions = OnlineSesions,
            AccountPrivacy = AccountPrivacy
        };
    }
}
