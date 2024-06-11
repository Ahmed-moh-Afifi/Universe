namespace UniverseBackend.Data;
public class Reaction
{
    public required int ID { get; set; }
    public required int PostID { get; set; }
    public required int UserID { get; set; }
    public required string ReactionType { get; set; }
    public required DateTime ReactionDate { get; set; }
}