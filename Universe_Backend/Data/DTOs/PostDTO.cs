using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs;

public class PostDTO
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
    public ICollection<Widget>? Widgets { get; set; }
    // public required string AuthorId { get; set; }
    public required UserDTO Author { get; set; }

    public Post ToModel()
    {
        return new Post
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
            AuthorId = Author.Id,
            Widgets = Widgets
        };
    }

    public static PostDTO FromPost(Post post)
    {
        return new PostDTO
        {
            Id = post.Id,
            Title = post.Title,
            Body = post.Body,
            Images = post.Images,
            Videos = post.Videos,
            Audios = post.Audios,
            PublishDate = post.PublishDate,
            ReplyToPost = post.ReplyToPost,
            ChildPostId = post.ChildPostId,
            Author = post.Author!.ToDTO(),
            Widgets = post.Widgets
        };
    }
}
