namespace Universe_Backend.Data.Models
{
    public class Message
    {
        public required int Id { get; set; }
        public required string Body { get; set; }
        public List<string> Images { get; set; } = [];
        public List<string> Videos { get; set; } = [];
        public List<string> Audios { get; set; } = [];
        public DateTime PublishDate { get; set; } = DateTime.Now;
        public int? ChildPostId { get; set; }
        public int? MessageRepliedTo { get; set; }
        public required string AuthorId { get; set; }
        public ICollection<Widget>? Widgets { get; set; }
        public int ReactionsCount { get; set; }
        public int RepliesCount { get; set; }
        public int ChatId { get; set; }

        public virtual User? Author { get; set; }
        public virtual Chat? Chat { get; set; }
        public virtual ICollection<PostReaction> Reactions { get; set; } = [];
        public virtual ICollection<User> Mentions { get; set; } = [];
    }
}
