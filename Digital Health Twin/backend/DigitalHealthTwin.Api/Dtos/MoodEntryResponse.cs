using DigitalHealthTwin.Api.Models;

namespace DigitalHealthTwin.Api.Dtos;

public class MoodEntryResponse
{
    public Guid Id { get; set; }

    public string Mood { get; set; } = string.Empty;

    public int StressLevel { get; set; }

    public double SleepHours { get; set; }

    public string? Notes { get; set; }

    public DateTimeOffset CreatedAt { get; set; }

    public static MoodEntryResponse FromModel(MoodEntry entry)
    {
        return new MoodEntryResponse
        {
            Id = entry.Id,
            Mood = entry.Mood,
            StressLevel = entry.StressLevel,
            SleepHours = entry.SleepHours,
            Notes = entry.Notes,
            CreatedAt = entry.CreatedAt
        };
    }
}
