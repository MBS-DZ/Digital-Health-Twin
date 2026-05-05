import 'package:flutter/material.dart';

class MoodStyles {
  const MoodStyles._();

  static const moods = ['happy', 'neutral', 'sad', 'stressed', 'anxious'];

  static Color colorFor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return const Color(0xFF16A34A);
      case 'sad':
        return const Color(0xFF2563EB);
      case 'stressed':
        return const Color(0xFFDC2626);
      case 'anxious':
        return const Color(0xFF9333EA);
      default:
        return const Color(0xFF64748B);
    }
  }

  static IconData iconFor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_satisfied_alt;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'stressed':
        return Icons.warning_amber_rounded;
      case 'anxious':
        return Icons.psychology_alt_outlined;
      default:
        return Icons.sentiment_neutral;
    }
  }
}
