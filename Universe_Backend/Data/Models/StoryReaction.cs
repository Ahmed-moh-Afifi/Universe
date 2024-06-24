namespace Universe_Backend.Data.Models;

public class StoryReaction : Reaction
{
    public int StoryId { get; set; }
    public virtual Story? Story { get; set; }
}
