# Digital Health Twin - Mental Health Module

This project is a small full-stack prototype for a Digital Health Twin mental health module. The Flutter app lets a user track mood, stress level, sleep hours, and notes. A .NET Web API stores entries in memory and returns simple rule-based mental health insights.

The implementation is intentionally simple, professional, and easy to explain in a technical interview. It uses REST, clear request/response models, basic validation, and a small service layer instead of over-engineering the task.

## Architecture

```text
Flutter app
  screens -> services -> backend REST API

.NET Web API
  controller -> mental health service -> in-memory list
```

The app does not talk directly to storage. It calls the backend through `MentalHealthApi`, which keeps network logic separate from UI code. The backend exposes three endpoints under `/mental` and keeps insight logic in `MentalHealthService`.

## Folder Structure

```text
backend/
  DigitalHealthTwin.Api/
    Controllers/
    Dtos/
    Models/
    Services/
    Program.cs

mobile/
  lib/
    models/
    screens/
    services/
    utils/
    widgets/
    main.dart
  test/

docs/
  TECHNICAL_EXPLANATION.md
```

## API Endpoints

| Method | Endpoint | Purpose |
| --- | --- | --- |
| `POST` | `/mental/add-mood` | Adds one mood entry |
| `GET` | `/mental/history` | Returns stored mood entries |
| `POST` | `/mental/analyze` | Returns rule-based insights |

Example request body for `POST /mental/add-mood`:

```json
{
  "mood": "stressed",
  "stressLevel": 8,
  "sleepHours": 5.5,
  "notes": "Long work day",
  "createdAt": "2026-05-04T10:00:00Z"
}
```

Allowed moods are `happy`, `sad`, `stressed`, `anxious`, and `neutral`.

## Run the Backend

Install the .NET 8 SDK, then run:

```powershell
dotnet run --project backend/DigitalHealthTwin.Api/DigitalHealthTwin.Api.csproj
```

The API runs at:

```text
http://localhost:5000
```

## Test the Backend Endpoints

PowerShell examples:

```powershell
Invoke-RestMethod -Method Post `
  -Uri http://localhost:5000/mental/add-mood `
  -ContentType "application/json" `
  -Body '{"mood":"stressed","stressLevel":8,"sleepHours":5.5,"notes":"Long work day","createdAt":"2026-05-04T10:00:00Z"}'
```

```powershell
Invoke-RestMethod -Method Get -Uri http://localhost:5000/mental/history
```

```powershell
Invoke-RestMethod -Method Post -Uri http://localhost:5000/mental/analyze
```

Validation check:

```powershell
Invoke-RestMethod -Method Post `
  -Uri http://localhost:5000/mental/add-mood `
  -ContentType "application/json" `
  -Body '{"mood":"angry","stressLevel":11,"sleepHours":30}'
```

This should return validation or unsupported mood feedback.

## Run the Flutter App

Install Flutter, then run:

```powershell
cd mobile
flutter pub get
```

If native platform folders have not been generated on your machine yet, run:

```powershell
flutter create --platforms=android,ios .
```

For Android emulator:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

For iOS simulator or Flutter desktop/web:

```powershell
flutter run --dart-define=API_BASE_URL=http://localhost:5000
```

For a physical phone, replace the URL with your computer LAN IP, for example:

```powershell
dotnet run --project backend/DigitalHealthTwin.Api/DigitalHealthTwin.Api.csproj --urls "http://0.0.0.0:5000"
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:5000
```

You may also need to allow port `5000` through your local firewall for physical-device testing.

## How the App Connects to the Backend

The API base URL is configured in:

```text
mobile/lib/services/api_config.dart
```

By default it uses `http://10.0.2.2:5000`, which is the Android emulator alias for the host computer. You can override it at runtime using `--dart-define=API_BASE_URL=...`.

## Test the Flutter App

1. Start the backend with `dotnet run`.
2. Start the app with the correct `API_BASE_URL`.
3. Open the Input tab.
4. Select a mood, choose stress, enter sleep hours, and save.
5. Confirm the success snackbar appears.
6. Check the History tab and pull to refresh if needed.
7. Add several stressed/anxious/sad entries with low sleep.
8. Open Insights and refresh to see warning messages.

Flutter test:

```powershell
cd mobile
flutter test
```

## Insight Logic

The backend currently uses simple rule-based logic over the latest seven entries:

- Low sleep plus high stress: average sleep below 6 hours and average stress at least 7.
- Repeated negative mood: at least 3 recent entries with `sad`, `stressed`, or `anxious`.
- Stable pattern: if no warning condition is met, return supportive feedback.

This is transparent and explainable, which is useful for a technical task and for health-related features where users should understand why feedback appears.

## Storage Choice

The backend stores mood entries in an in-memory list. This is appropriate for a 24-hour prototype because it is fast to build, easy to review, and has no database setup requirement.

Tradeoff: data disappears when the API restarts. A production version should use SQLite for a local prototype, PostgreSQL for a real backend, or Firestore/Supabase for managed cloud storage.

## Screenshots/Demo Section

Suggested screenshots for submission:

- Mood Input Screen with selected mood and filled form.
- Success snackbar after saving.
- Mood History Screen showing multiple entries.
- Insights Screen showing average stress, sleep, and generated messages.

Suggested demo flow:

1. Start API.
2. Add one stable mood entry.
3. Show history.
4. Add three negative high-stress low-sleep entries.
5. Show insights changing from supportive feedback to warnings.

## Possible Improvements

- Persist entries in SQLite, PostgreSQL, Firebase, or Supabase.
- Add authentication so entries belong to a real user.
- Add date filters and trend charts.
- Add offline-first local caching in Flutter.
- Add stronger backend tests and integration tests.
- Add a real AI insight service with safety rules and clinician-approved prompts.
- Add privacy controls, encryption, consent screens, and disclaimers for health data.

## Alternative Implementation Approaches

See [docs/TECHNICAL_EXPLANATION.md](docs/TECHNICAL_EXPLANATION.md) for frontend, backend, storage, insight logic, integration alternatives, and interview-style talking points.
