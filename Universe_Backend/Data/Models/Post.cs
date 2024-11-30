using System.ComponentModel.DataAnnotations.Schema;
using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Data.Models;

public class Post
{
    public required int Id { get; set; }
    public required string Uid { get; set; }
    public required string? Title { get; set; }
    public required string Body { get; set; }
    public List<string> Images { get; set; } = [];
    public List<string> Videos { get; set; } = [];
    public List<string> Audios { get; set; } = [];
    public DateTime PublishDate { get; set; } = DateTime.Now;
    public int? ReplyToPostId { get; set; }
    public int? ChildPostId { get; set; }
    public required string AuthorId { get; set; }
    public ICollection<Widget>? Widgets { get; set; }
    public int ReactionsCount { get; set; }
    public int RepliesCount { get; set; }

    public virtual User? Author { get; set; }
    public virtual Post? ReplyToPost { get; set; }
    public virtual Post? ChildPost { get; set; }
    public virtual ICollection<PostReaction> Reactions { get; set; } = [];
    public virtual ICollection<Tag> Tags { get; set; } = [];
    public virtual ICollection<User> Mentions { get; set; } = [];

    public PostDTO ToDTO()
    {
        return new PostDTO
        {
            Id = Id,
            Uid = Uid,
            Title = Title,
            Body = Body,
            Images = Images,
            Videos = Videos,
            Audios = Audios,
            PublishDate = PublishDate,
            ReplyToPostId = ReplyToPostId,
            ChildPostId = ChildPostId,
            Widgets = Widgets,
            Author = Author!.ToDTO(),
            ReactionsCount = ReactionsCount,
            RepliesCount = RepliesCount,
            ReplyToPost = ReplyToPost?.ToDTO(),
            ChildPost = ChildPost?.ToDTO()
        };
    }

    public Post UpdateFromDTO(PostDTO post)
    {
        Title = post.Title;
        Body = post.Body;
        Images = post.Images;
        Videos = post.Videos;
        Audios = post.Audios;
        PublishDate = post.PublishDate;
        ReplyToPostId = post.ReplyToPostId;
        ChildPostId = post.ChildPostId;
        AuthorId = post.Author.Id;
        Widgets = post.Widgets;
        ReactionsCount = post.ReactionsCount;
        RepliesCount = post.RepliesCount;
        return this;
    }
}