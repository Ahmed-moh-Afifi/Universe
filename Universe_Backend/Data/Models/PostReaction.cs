using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Data.Models;

public class PostReaction : Reaction
{
    public int PostId { get; set; }
    public virtual Post? Post { get; set; }

    public PostReactionDTO ToDTO()
    {
        return new PostReactionDTO
        {
            Id = Id,
            UserId = UserId,
            ReactionType = ReactionType,
            ReactionDate = ReactionDate,
            PostId = PostId
        };
    }
}