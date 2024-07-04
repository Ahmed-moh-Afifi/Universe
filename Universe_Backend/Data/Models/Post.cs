using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Data.Models;

public class Post
{
    public required int Id { get; set; }
    public required string? Title { get; set; }
    public required string Body { get; set; }
    public List<string> Images { get; set; } = [];
    public List<string> Videos { get; set; } = [];
    public List<string> Audios { get; set; } = [];
    public DateTime PublishDate { get; set; } = DateTime.Now;
    public int? ReplyToPost { get; set; }
    public int? ChildPostId { get; set; }
    public required string AuthorId { get; set; }
    public ICollection<Widget>? Widgets { get; set; }

    public virtual User? Author { get; set; }
    public virtual ICollection<PostReaction> Reactions { get; set; } = [];
    public virtual ICollection<Tag> Tags { get; set; } = [];
    public virtual ICollection<User> Mentions { get; set; } = [];

    public PostDTO ToDTO()
    {
        return new PostDTO
        {
            Id = Id,
            Title = Title,
            Body = Body,
            Images = Images,
            Videos = Videos,
            Audios = Audios,
            PublishDate = PublishDate,
            ReplyToPost = ReplyToPost,
            ChildPostId = ChildPostId,
            AuthorId = AuthorId,
            Widgets = Widgets
        };
    }
}