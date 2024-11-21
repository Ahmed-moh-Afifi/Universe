using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Data.Models;

public class StoryReaction : Reaction
{
    public int StoryId { get; set; }
    public virtual Story? Story { get; set; }

    public StoryReactionDTO ToDTO()
    {
        return new StoryReactionDTO
        {
            Id = Id,
            UserId = UserId,
            ReactionType = ReactionType,
            ReactionDate = ReactionDate,
            StoryId = StoryId
        };
    }
}
