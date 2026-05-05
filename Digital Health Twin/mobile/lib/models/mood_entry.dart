class MoodEntry {
  const MoodEntry({
    this.id,
    required this.mood,
    required this.stressLevel,
    required this.sleepHours,
    this.notes,
    required this.createdAt,
  });

  final String? id;
  final String mood;
  final int stressLevel;
  final double sleepHours;
  final String? notes;
  final DateTime createdAt;

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String?,
      mood: json['mood'] as String,
      stressLevel: json['stressLevel'] as int,
      sleepHours: (json['sleepHours'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mood': mood,
      'stressLevel': stressLevel,
      'sleepHours': sleepHours,
      'notes': notes,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }
}
