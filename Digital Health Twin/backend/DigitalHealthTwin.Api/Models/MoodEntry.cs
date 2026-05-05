namespace DigitalHealthTwin.Api.Models;

public class MoodEntry
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public string Mood { get; set; } = string.Empty;

    public int StressLevel { get; set; }

    public double SleepHours { get; set; }

    public string? Notes { get; set; }

    public DateTimeOffset CreatedAt { get; set; }
}
