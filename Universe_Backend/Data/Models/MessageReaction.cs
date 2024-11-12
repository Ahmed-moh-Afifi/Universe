namespace Universe_Backend.Data.Models
{
    public class MessageReaction : Reaction
    {
        public int MessageId { get; set; }
        public virtual Message? Message { get; set; }
    }
}
