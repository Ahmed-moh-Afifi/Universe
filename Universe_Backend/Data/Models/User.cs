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
    public List<string>? Links { get; set; }
    public AccountState AccountState { get; set; } = AccountState.Active;
    public DateTime? LastOnline { get; set; }
    public int OnlineSessions { get; set; }
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
    public virtual ICollection<Chat> Chats { get; set; } = [];
    public virtual ICollection<Message> Messages { get; set; } = [];
    public virtual ICollection<Message> MessagesMentionedIn { get; set; } = [];

    public static User FromRegisterModel(RegisterModel model)
    {
        return new User
        {
            FirstName = model.FirstName,
            LastName = model.LastName,
            Gender = model.Gender,
            Email = model.Email,
            UserName = model.Username,
            OnlineSessions = 0,
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
            Links = Links,
            AccountState = AccountState,
            LastOnline = LastOnline,
            OnlineSessions = OnlineSessions,
            AccountPrivacy = AccountPrivacy
        };
    }

    public void UpdateFromDTO(UserDTO dto)
    {
        FirstName = dto.FirstName;
        LastName = dto.LastName;
        Gender = dto.Gender;
        Email = dto.Email;
        UserName = dto.UserName;
        PhotoUrl = dto.PhotoUrl;
        Bio = dto.Bio;
        Links = dto.Links;
        AccountState = dto.AccountState;
        LastOnline = dto.LastOnline;
        OnlineSessions = dto.OnlineSessions;
        AccountPrivacy = dto.AccountPrivacy;
        Verified = dto.Verified;
    }
}