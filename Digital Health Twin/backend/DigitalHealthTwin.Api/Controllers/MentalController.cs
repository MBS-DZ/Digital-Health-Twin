using DigitalHealthTwin.Api.Dtos;
using DigitalHealthTwin.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace DigitalHealthTwin.Api.Controllers;

[ApiController]
[Route("mental")]
public class MentalController : ControllerBase
{
    private static readonly HashSet<string> AllowedMoods = new(StringComparer.OrdinalIgnoreCase)
    {
        "happy",
        "sad",
        "stressed",
        "anxious",
        "neutral"
    };

    private readonly IMentalHealthService _mentalHealthService;

    public MentalController(IMentalHealthService mentalHealthService)
    {
        _mentalHealthService = mentalHealthService;
    }

    [HttpPost("add-mood")]
    public ActionResult<MoodEntryResponse> AddMood([FromBody] AddMoodRequest request)
    {
        if (!AllowedMoods.Contains(request.Mood))
        {
            return BadRequest(new
            {
                error = "Unsupported mood.",
                allowedMoods = AllowedMoods.OrderBy(mood => mood)
            });
        }

        var entry = _mentalHealthService.AddMood(request);
        return CreatedAtAction(nameof(GetHistory), new { id = entry.Id }, MoodEntryResponse.FromModel(entry));
    }

    [HttpGet("history")]
    public ActionResult<IReadOnlyList<MoodEntryResponse>> GetHistory()
    {
        var entries = _mentalHealthService
            .GetHistory()
            .Select(MoodEntryResponse.FromModel)
            .ToList();

        return Ok(entries);
    }

    [HttpPost("analyze")]
    public ActionResult<MentalInsightResponse> Analyze()
    {
        return Ok(_mentalHealthService.Analyze());
    }
}
