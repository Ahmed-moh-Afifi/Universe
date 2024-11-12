namespace Universe_Backend.Data.Models
{
    public class InAppNotification
    {
        public required string Title { get; set; }
        public required string Body { get; set; }
        public required string Sender { get; set; }
        public required string Recipient { get; set; }
    }
}
