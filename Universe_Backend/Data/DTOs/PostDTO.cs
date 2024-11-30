using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs;

public class PostDTO
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
    public ICollection<Widget>? Widgets { get; set; }
    public required UserDTO Author { get; set; }
    public int ReactionsCount { get; set; }
    public int RepliesCount { get; set; }
    public bool ReactedToByCaller { get; set; }
    public PostReactionDTO? CallerReaction { get; set; }
    public PostDTO? ReplyToPost { get; set; }
    public PostDTO? ChildPost { get; set; }

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
            ReplyToPostId = ReplyToPostId,
            ChildPostId = ChildPostId,
            AuthorId = Author.Id,
            Widgets = Widgets,
            ReactionsCount = ReactionsCount,
            RepliesCount = RepliesCount
        };
    }

    public static PostDTO FromPost(Post post, bool reactedToByCaller, PostReactionDTO? callerReaction, bool? childReactedToByCaller, PostReactionDTO? childCallerReaction)
    {
        return new PostDTO
        {
            Id = post.Id,
            Uid = post.Uid,
            Title = post.Title,
            Body = post.Body,
            Images = post.Images,
            Videos = post.Videos,
            Audios = post.Audios,
            PublishDate = post.PublishDate,
            ReplyToPostId = post.ReplyToPostId,
            ChildPostId = post.ChildPostId,
            Author = post.Author!.ToDTO(),
            Widgets = post.Widgets,
            ReactionsCount = post.ReactionsCount,
            RepliesCount = post.RepliesCount,
            ReactedToByCaller = reactedToByCaller,
            CallerReaction = callerReaction,
            ReplyToPost = post.ReplyToPost?.ToDTO(),
            ChildPost = post.ChildPost != null ? PostDTO.FromPost(post.ChildPost, childReactedToByCaller ?? false, childCallerReaction, null, null) : null
        };
    }
}
