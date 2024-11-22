using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs;

public class StoryReactionDTO
{
    public required int Id { get; set; }
    public required string UserId { get; set; }
    public required string ReactionType { get; set; }
    public DateTime ReactionDate { get; set; } = DateTime.Now;
    public int StoryId { get; set; }

    public StoryReaction ToModel()
    {
        return new StoryReaction
        {
            Id = Id,
            UserId = UserId,
            ReactionType = ReactionType,
            ReactionDate = ReactionDate,
            StoryId = StoryId
        };
    }
}
