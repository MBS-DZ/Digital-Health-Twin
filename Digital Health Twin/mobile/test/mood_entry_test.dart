import 'package:digital_health_twin/models/mood_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MoodEntry serializes request body for backend', () {
    final entry = MoodEntry(
      mood: 'happy',
      stressLevel: 3,
      sleepHours: 7.5,
      notes: 'Good day',
      createdAt: DateTime.utc(2026, 5, 4, 10),
    );

    expect(entry.toJson(), {
      'mood': 'happy',
      'stressLevel': 3,
      'sleepHours': 7.5,
      'notes': 'Good day',
      'createdAt': '2026-05-04T10:00:00.000Z',
    });
  });
}
