using Universe_Backend.Data.DTOs;

namespace Universe_Backend.Data.Models
{
    public enum ChatType
    {
        User,
        Group,
    }

    public class Chat
    {
        public int Id { get; set; }
        public required string Name { get; set; }
        public required DateTime LastEdited { get; set; }

        public virtual ICollection<User> Users { get; set; } = [];
        public virtual ICollection<Message> Messages { get; set; } = [];

        public ChatDTO ToDTO()
        {
            return new ChatDTO
            {
                Id = Id,
                Name = Name,
                LastEdited = LastEdited,
                Users = Users.Select(u => u.ToDTO()).ToList(),
                Messages = Messages.Select(m => m.ToDTO()).ToList(),
            };
        }
    }
}
