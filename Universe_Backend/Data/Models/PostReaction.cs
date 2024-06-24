namespace Universe_Backend.Data.Models;

public class PostReaction : Reaction
{
    public int PostId { get; set; }
    public virtual Post? Post { get; set; }
}