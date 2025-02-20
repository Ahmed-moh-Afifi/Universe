using Universe_Backend.Data.Models;

namespace Universe_Backend.Data.DTOs
{
    public class ChatDTO
    {
        public int Id { get; set; }
        public required string Name { get; set; }
        public required DateTime LastEdited { get; set; }
        public string? PhotoUrl { get; set; }

        public required List<UserDTO> Users { get; set; }
        public required List<MessageDTO> Messages { get; set; }
    }
}
