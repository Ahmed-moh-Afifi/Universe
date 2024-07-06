using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Data.Models;

public class Story
{
    public int Id { get; set; }
    public required string? Content { get; set; }
    public required string? Image { get; set; }
    public required string? Video { get; set; }
    public required string? Audio { get; set; }
    public DateTime PublishDate { get; set; } = DateTime.Now;
    public required string AuthorId { get; set; }
    public int? SharedPostId { get; set; }
    public int? SharedStoryId { get; set; }
    public ICollection<Widget>? Widgets { get; set; }

    public Post? SharedPost { get; set; }
    public Story? SharedStory { get; set; }
    public virtual User? Author { get; set; }
    public virtual ICollection<User> Mentions { get; set; } = [];
    public virtual ICollection<Tag> Tags { get; set; } = [];
    public virtual ICollection<StoryReaction> Reactions { get; set; } = [];

    public bool IsActive()
    {
        return DateTime.Now.Subtract(PublishDate).TotalHours < 24;
    }

    public StoryDTO ToDTO()
    {
        return new StoryDTO
        {
            Id = Id,
            Content = Content,
            Image = Image,
            Video = Video,
            Audio = Audio,
            PublishDate = PublishDate,
            AuthorId = AuthorId,
            SharedPostId = SharedPostId,
            SharedStoryId = SharedStoryId,
            Widgets = Widgets
        };
    }

    public Story UpdateFromDTO(StoryDTO story)
    {
        Content = story.Content;
        Image = story.Image;
        Video = story.Video;
        Audio = story.Audio;
        PublishDate = story.PublishDate;
        AuthorId = story.AuthorId;
        SharedPostId = story.SharedPostId;
        SharedStoryId = story.SharedStoryId;
        Widgets = story.Widgets;
        return this;
    }
}