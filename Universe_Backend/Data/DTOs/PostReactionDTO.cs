using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs;

public class PostReactionDTO
{
    public required int Id { get; set; }
    public required string UserId { get; set; }
    public required string ReactionType { get; set; }
    public DateTime ReactionDate { get; set; } = DateTime.Now;
    public int PostId { get; set; }

    public PostReaction ToModel()
    {
        return new PostReaction
        {
            Id = Id,
            UserId = UserId,
            ReactionType = ReactionType,
            ReactionDate = ReactionDate,
            PostId = PostId
        };
    }
}
