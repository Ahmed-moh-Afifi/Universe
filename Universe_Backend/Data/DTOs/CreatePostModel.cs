using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs
{
    public class CreatePostModel
    {
        public required int Id { get; set; }
        public required string Uid { get; set; }
        public required string? Title { get; set; }
        public required string Body { get; set; }
        public List<string> Images { get; set; } = [];
        public List<string> Videos { get; set; } = [];
        public List<string> Audios { get; set; } = [];
        public DateTime PublishDate { get; set; } = DateTime.Now;
        public int? ReplyToPost { get; set; }
        public int? ChildPostId { get; set; }
        public ICollection<Widget>? Widgets { get; set; }
        public required UserDTO Author { get; set; }
        public int ReactionsCount { get; set; }
        public int RepliesCount { get; set; }
        public bool ReactedToByCaller { get; set; }
        public PostReactionDTO? CallerReaction { get; set; }

        public Post ToModel()
        {
            return new Post
            {
                Id = Id,
                Uid = Uid,
                Title = Title,
                Body = Body,
                Images = Images,
                Videos = Videos,
                Audios = Audios,
                PublishDate = PublishDate,
                ReplyToPost = ReplyToPost,
                ChildPostId = ChildPostId,
                AuthorId = Author.Id,
                Widgets = Widgets,
                ReactionsCount = ReactionsCount,
                RepliesCount = RepliesCount
            };
        }
    }
}
