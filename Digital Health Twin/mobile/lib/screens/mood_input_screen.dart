import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import '../services/mental_health_api.dart';
import '../widgets/mood_selector.dart';

class MoodInputScreen extends StatefulWidget {
  const MoodInputScreen({super.key, required this.onMoodSaved});

  final VoidCallback onMoodSaved;

  @override
  State<MoodInputScreen> createState() => _MoodInputScreenState();
}

class _MoodInputScreenState extends State<MoodInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = MentalHealthApi();
  final _sleepController = TextEditingController(text: '7');
  final _notesController = TextEditingController();

  String _selectedMood = 'neutral';
  double _stressLevel = 5;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _sleepController.dispose();
    _notesController.dispose();
    _api.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _api.addMood(
        MoodEntry(
          mood: _selectedMood,
          stressLevel: _stressLevel.round(),
          sleepHours: double.parse(_sleepController.text),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          createdAt: DateTime.now(),
        ),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood entry saved successfully.')),
      );
      _notesController.clear();
      widget.onMoodSaved();
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track mood, stress, sleep, and notes in one quick entry.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Mood',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            MoodSelector(
              selectedMood: _selectedMood,
              onChanged: (mood) {
                setState(() => _selectedMood = mood);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Stress level: ${_stressLevel.round()}/10',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _stressLevel,
              min: 1,
              max: 10,
              divisions: 9,
              label: _stressLevel.round().toString(),
              onChanged: (value) {
                setState(() => _stressLevel = value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sleepController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Sleep hours',
                prefixIcon: Icon(Icons.bedtime_outlined),
              ),
              validator: (value) {
                final sleepHours = double.tryParse(value ?? '');
                if (sleepHours == null) {
                  return 'Enter sleep hours as a number.';
                }
                if (sleepHours < 0 || sleepHours > 24) {
                  return 'Sleep hours must be between 0 and 24.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Notes optional',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(_isSubmitting ? 'Saving...' : 'Save mood entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
