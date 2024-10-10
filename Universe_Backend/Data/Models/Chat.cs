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

        public virtual ICollection<User> Users { get; set; } = [];
        public virtual ICollection<Message> Messages { get; set; } = [];
    }
}
