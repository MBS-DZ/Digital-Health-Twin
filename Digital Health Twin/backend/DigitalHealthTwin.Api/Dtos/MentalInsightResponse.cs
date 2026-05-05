namespace DigitalHealthTwin.Api.Dtos;

public class MentalInsightResponse
{
    public string Summary { get; set; } = string.Empty;

    public List<string> Messages { get; set; } = [];

    public int TotalEntries { get; set; }

    public double AverageStressLevel { get; set; }

    public double AverageSleepHours { get; set; }

    public int RecentNegativeMoodCount { get; set; }

    public DateTimeOffset GeneratedAt { get; set; }
}
