using Microsoft.EntityFrameworkCore;

namespace Universe_Backend.Data.Models;

public enum WidgetType
{
    Music,
    Poll,
    StopWatch,
    Rate,
    Location,
    Code,
    Question,
    Answer,
}

[Owned]
public class Widget
{
    public required WidgetType Type { get; set; }
    public required string Title { get; set; }
    public required string Body { get; set; }
    public required string Data { get; set; }
}
