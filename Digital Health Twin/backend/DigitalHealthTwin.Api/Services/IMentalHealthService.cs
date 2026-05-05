using DigitalHealthTwin.Api.Dtos;
using DigitalHealthTwin.Api.Models;

namespace DigitalHealthTwin.Api.Services;

public interface IMentalHealthService
{
    MoodEntry AddMood(AddMoodRequest request);

    IReadOnlyList<MoodEntry> GetHistory();

    MentalInsightResponse Analyze();
}
