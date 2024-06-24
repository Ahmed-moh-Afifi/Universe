namespace Universe_Backend.Data.Models;

public class Reaction
{
    public required int Id { get; set; }
    public required string UserId { get; set; }
    public required string ReactionType { get; set; }
    public DateTime ReactionDate { get; set; } = DateTime.Now;

    public virtual User? User { get; set; }
}