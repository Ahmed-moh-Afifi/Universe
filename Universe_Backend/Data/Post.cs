namespace UniverseBackend.Data;

public class Post
{
    public required int ID { get; set; }
    public required int AuthorID { get; set; }
    public required string Title { get; set; }
    public required string Body { get; set; }
    public required List<string> Images { get; set; }
    public required List<string> Videos { get; set; }
    public required DateTime PublishDate { get; set; }
    public required int ParentPostID { get; set; }
}