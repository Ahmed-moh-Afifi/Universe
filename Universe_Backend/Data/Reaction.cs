class Reaction
{
    public required int ID { get; set; }
    public required int PostId { get; set; }
    public required string ReactionType { get; set; }
    public required DateTime ReactionDate { get; set; }
}