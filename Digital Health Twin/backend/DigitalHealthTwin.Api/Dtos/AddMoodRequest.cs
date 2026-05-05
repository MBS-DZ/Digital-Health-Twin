using System.ComponentModel.DataAnnotations;

namespace DigitalHealthTwin.Api.Dtos;

public class AddMoodRequest
{
    [Required]
    [MaxLength(30)]
    public string Mood { get; set; } = string.Empty;

    [Range(1, 10)]
    public int StressLevel { get; set; }

    [Range(0, 24)]
    public double SleepHours { get; set; }

    [MaxLength(500)]
    public string? Notes { get; set; }

    public DateTimeOffset? CreatedAt { get; set; }
}
