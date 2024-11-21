using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs;

public class StoryDTO
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

    public Story ToModel()
    {
        return new Story
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
}
