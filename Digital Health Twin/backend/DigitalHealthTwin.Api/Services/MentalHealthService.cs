using DigitalHealthTwin.Api.Dtos;
using DigitalHealthTwin.Api.Models;

namespace DigitalHealthTwin.Api.Services;

public class MentalHealthService : IMentalHealthService
{
    private static readonly HashSet<string> NegativeMoods = new(StringComparer.OrdinalIgnoreCase)
    {
        "sad",
        "stressed",
        "anxious"
    };

    private readonly List<MoodEntry> _entries = [];
    private readonly object _lock = new();

    public MoodEntry AddMood(AddMoodRequest request)
    {
        var entry = new MoodEntry
        {
            Mood = request.Mood.Trim().ToLowerInvariant(),
            StressLevel = request.StressLevel,
            SleepHours = Math.Round(request.SleepHours, 1),
            Notes = string.IsNullOrWhiteSpace(request.Notes) ? null : request.Notes.Trim(),
            CreatedAt = request.CreatedAt ?? DateTimeOffset.UtcNow
        };

        lock (_lock)
        {
            _entries.Add(entry);
        }

        return entry;
    }

    public IReadOnlyList<MoodEntry> GetHistory()
    {
        lock (_lock)
        {
            return _entries
                .OrderByDescending(entry => entry.CreatedAt)
                .ToList();
        }
    }

    public MentalInsightResponse Analyze()
    {
        var entries = GetHistory();

        if (entries.Count == 0)
        {
            return new MentalInsightResponse
            {
                Summary = "No mood entries yet.",
                Messages =
                [
                    "Add your first mood entry to receive a basic mental health insight."
                ],
                GeneratedAt = DateTimeOffset.UtcNow
            };
        }

        var recentEntries = entries.Take(7).ToList();
        var averageStress = recentEntries.Average(entry => entry.StressLevel);
        var averageSleep = recentEntries.Average(entry => entry.SleepHours);
        var negativeMoodCount = recentEntries.Count(entry => NegativeMoods.Contains(entry.Mood));
        var messages = new List<string>();

        // These thresholds are intentionally simple so the evaluator can follow the logic quickly.
        if (averageSleep < 6 && averageStress >= 7)
        {
            messages.Add("You reported low sleep and high stress. Consider resting and reducing workload.");
        }

        if (negativeMoodCount >= 3)
        {
            messages.Add("You have reported negative moods several times recently. Consider taking a break or speaking with someone you trust.");
        }

        if (messages.Count == 0)
        {
            messages.Add("Your mood, stress, and sleep look relatively stable. Keep maintaining healthy routines.");
        }

        return new MentalInsightResponse
        {
            Summary = BuildSummary(averageStress, averageSleep, negativeMoodCount),
            Messages = messages,
            TotalEntries = entries.Count,
            AverageStressLevel = Math.Round(averageStress, 1),
            AverageSleepHours = Math.Round(averageSleep, 1),
            RecentNegativeMoodCount = negativeMoodCount,
            GeneratedAt = DateTimeOffset.UtcNow
        };
    }

    private static string BuildSummary(double averageStress, double averageSleep, int negativeMoodCount)
    {
        return $"Recent average stress is {averageStress:0.0}/10, average sleep is {averageSleep:0.0} hours, and negative mood entries appeared {negativeMoodCount} time(s).";
    }
}
