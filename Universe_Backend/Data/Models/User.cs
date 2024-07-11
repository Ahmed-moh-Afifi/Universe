using Microsoft.AspNetCore.Identity;
using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Data.Models;

public enum AccountState
{
    Active,
    Suspended,
    Banned,
    Deleted
}

public enum OnlineStatus
{
    Online,
    Offline,
}

public enum AccountPrivacy
{
    Public,
    Private,
}

public class User : IdentityUser
{
    public required string FirstName { get; set; }
    public required string LastName { get; set; }
    public required bool Gender { get; set; }
    public DateTime JoinDate { get; set; } = DateTime.Now;
    public string? PhotoUrl { get; set; } = null;
    public bool Verified { get; set; } = false;
    public string? Bio { get; set; }
    public AccountState AccountState { get; set; } = AccountState.Active;
    public DateTime? LastOnline { get; set; }
    public required OnlineStatus OnlineStatus { get; set; } = OnlineStatus.Online;
    public AccountPrivacy AccountPrivacy { get; set; } = AccountPrivacy.Public;

    public ICollection<NotificationToken> NotificationTokens { get; set; } = [];
    public virtual ICollection<User> Followers { get; set; } = [];
    public virtual ICollection<User> Following { get; set; } = [];
    public virtual ICollection<Post> Posts { get; set; } = [];
    public virtual ICollection<Story> Stories { get; set; } = [];
    public virtual ICollection<Post> PostsMentionedIn { get; set; } = [];
    public virtual ICollection<Story> StoriesMentionedIn { get; set; } = [];
    public virtual ICollection<PostReaction> PostReactions { get; set; } = [];
    public virtual ICollection<StoryReaction> StoryReactions { get; set; } = [];

    public static User FromRegisterModel(RegisterModel model)
    {
        return new User
        {
            FirstName = model.FirstName,
            LastName = model.LastName,
            Gender = model.Gender,
            Email = model.Email,
            UserName = model.Username,
            OnlineStatus = OnlineStatus.Online,
        };
    }

    public UserDTO ToDTO()
    {
        return new UserDTO
        {
            Id = Id,
            FirstName = FirstName,
            LastName = LastName,
            Gender = Gender,
            Email = Email!,
            UserName = UserName!,
            JoinDate = JoinDate,
            PhotoUrl = PhotoUrl,
            Verified = Verified,
            Bio = Bio,
            AccountState = AccountState,
            LastOnline = LastOnline,
            OnlineStatus = OnlineStatus,
            AccountPrivacy = AccountPrivacy
        };
    }
}