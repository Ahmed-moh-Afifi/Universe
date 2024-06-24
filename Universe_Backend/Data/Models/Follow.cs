namespace Universe_Backend.Data.Models;

public class Follow
{
    public required string FollowerId { get; set; }
    public required string FollowedId { get; set; }
    public DateTime FollowDate { get; set; } = DateTime.Now;
}