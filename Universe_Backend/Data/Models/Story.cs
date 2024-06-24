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

    public virtual User? Author { get; set; }
    public virtual ICollection<User> Mentions { get; set; } = [];
    public virtual ICollection<Tag> Tags { get; set; } = [];
    public virtual ICollection<StoryReaction> Reactions { get; set; } = [];
}
