using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Data.Models;

public class Tag
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public string? Description { get; set; }
    public DateTime CreateDate { get; set; } = DateTime.Now;

    public virtual ICollection<Story> Stories { get; set; } = [];
    public virtual ICollection<Post> Posts { get; set; } = [];

    public TagDTO ToDTO()
    {
        return new TagDTO
        {
            Id = Id,
            Name = Name,
            Description = Description,
            CreateDate = CreateDate
        };
    }
}
