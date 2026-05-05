class MentalInsight {
  const MentalInsight({
    required this.summary,
    required this.messages,
    required this.totalEntries,
    required this.averageStressLevel,
    required this.averageSleepHours,
    required this.recentNegativeMoodCount,
    required this.generatedAt,
  });

  final String summary;
  final List<String> messages;
  final int totalEntries;
  final double averageStressLevel;
  final double averageSleepHours;
  final int recentNegativeMoodCount;
  final DateTime generatedAt;

  factory MentalInsight.fromJson(Map<String, dynamic> json) {
    return MentalInsight(
      summary: json['summary'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((message) => message as String)
          .toList(),
      totalEntries: json['totalEntries'] as int,
      averageStressLevel: (json['averageStressLevel'] as num).toDouble(),
      averageSleepHours: (json['averageSleepHours'] as num).toDouble(),
      recentNegativeMoodCount: json['recentNegativeMoodCount'] as int,
      generatedAt: DateTime.parse(json['generatedAt'] as String).toLocal(),
    );
  }
}
