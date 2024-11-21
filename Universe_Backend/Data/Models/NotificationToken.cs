
using NotificationService.Models;

namespace Universe_Backend.Data.Models;

public class NotificationToken
{
    public int Id { get; set; }
    public required string UserId { get; set; }
    public required string Token { get; set; }
    public required Platform Platform { get; set; }
    public required DateTime CreatedAt { get; set; } = DateTime.Now;
    public User? User { get; set; }
}
