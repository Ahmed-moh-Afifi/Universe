using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs;

public class TagDTO
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public string? Description { get; set; }
    public DateTime CreateDate { get; set; } = DateTime.Now;

    public Tag ToModel()
    {
        return new Tag
        {
            Id = Id,
            Name = Name,
            Description = Description,
            CreateDate = CreateDate
        };
    }
}
