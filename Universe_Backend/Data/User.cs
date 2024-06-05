namespace UniverseBackend.Data;

public class User
{
    public required int ID { get; set; }
    public required string FirstName { get; set; }
    public required string LastName { get; set; }
    public required string Email { get; set; }
    public required bool Gender { get; set; }
    public required DateTime JoinDate { get; set; }
    public required string PhotoUrl { get; set; }
    public required string UserName { get; set; }
    public required bool Verified { get; set; }
}