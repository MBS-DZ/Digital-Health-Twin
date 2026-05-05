import 'package:flutter/material.dart';

import '../utils/mood_styles.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onChanged,
  });

  final String selectedMood;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: MoodStyles.moods.map((mood) {
        final isSelected = selectedMood == mood;
        return ChoiceChip(
          avatar: Icon(
            MoodStyles.iconFor(mood),
            size: 18,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : MoodStyles.colorFor(mood),
          ),
          label: Text(_titleCase(mood)),
          selected: isSelected,
          onSelected: (_) => onChanged(mood),
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(
            color: isSelected ? Theme.of(context).colorScheme.onPrimary : null,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        );
      }).toList(),
    );
  }

  String _titleCase(String value) {
    return value.substring(0, 1).toUpperCase() + value.substring(1);
  }
}
