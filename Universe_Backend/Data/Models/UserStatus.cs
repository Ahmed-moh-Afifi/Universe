namespace Universe_Backend.Data.Models
{
    public class UserStatus
    {
        public required string Status { get; set; }
        public required DateTime LastOnline { get; set; }
    }
}
