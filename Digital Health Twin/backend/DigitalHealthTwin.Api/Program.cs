using DigitalHealthTwin.Api.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddSingleton<IMentalHealthService, MentalHealthService>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("DevelopmentCors", policy =>
    {
        policy
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowAnyOrigin();
    });
});

var app = builder.Build();

app.UseCors("DevelopmentCors");
app.MapControllers();

app.MapGet("/", () => Results.Ok(new
{
    name = "Digital Health Twin Mental Health API",
    status = "running",
    endpoints = new[]
    {
        "POST /mental/add-mood",
        "GET /mental/history",
        "POST /mental/analyze"
    }
}));

app.Run();
