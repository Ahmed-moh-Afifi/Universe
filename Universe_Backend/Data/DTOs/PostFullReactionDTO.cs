
using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs
{
    public class PostFullReactionDTO
    {
        public required int Id { get; set; }
        public required string UserId { get; set; }
        public required string ReactionType { get; set; }
        public DateTime ReactionDate { get; set; } = DateTime.Now;
        public int PostId { get; set; }
        public required UserDTO User { get; set; }

        public static PostFullReactionDTO FromModel(PostReaction reaction)
        {
            return new PostFullReactionDTO
            {
                Id = reaction.Id,
                UserId = reaction.UserId,
                ReactionType = reaction.ReactionType,
                ReactionDate = reaction.ReactionDate,
                PostId = reaction.PostId,
                User = reaction.User!.ToDTO()
            };
        }
    }
}
