import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/mood_entry.dart';
import '../services/mental_health_api.dart';
import '../utils/mood_styles.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  final _api = MentalHealthApi();
  late Future<List<MoodEntry>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _api.getHistory();
  }

  Future<void> _refresh() async {
    setState(() {
      _historyFuture = _api.getHistory();
    });
    await _historyFuture;
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MoodEntry>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _ErrorState(
            message: snapshot.error.toString(),
            onRetry: _refresh,
          );
        }

        final entries = snapshot.data ?? [];

        if (entries.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: const [
                SizedBox(height: 80),
                Icon(Icons.history, size: 56),
                SizedBox(height: 16),
                Center(child: Text('No mood entries yet.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _MoodHistoryCard(entry: entries[index]);
            },
          ),
        );
      },
    );
  }
}

class _MoodHistoryCard extends StatelessWidget {
  const _MoodHistoryCard({required this.entry});

  final MoodEntry entry;

  @override
  Widget build(BuildContext context) {
    final moodColor = MoodStyles.colorFor(entry.mood);
    final formattedDate = DateFormat('MMM d, yyyy - HH:mm').format(entry.createdAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: moodColor.withOpacity(0.14),
                  foregroundColor: moodColor,
                  child: Icon(MoodStyles.iconFor(entry.mood)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _titleCase(entry.mood),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(formattedDate),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _SmallMetric(
                  icon: Icons.speed_outlined,
                  label: 'Stress',
                  value: '${entry.stressLevel}/10',
                ),
                const SizedBox(width: 10),
                _SmallMetric(
                  icon: Icons.bedtime_outlined,
                  label: 'Sleep',
                  value: '${entry.sleepHours.toStringAsFixed(1)} h',
                ),
              ],
            ),
            if (entry.notes != null) ...[
              const SizedBox(height: 12),
              Text(entry.notes!),
            ],
          ],
        ),
      ),
    );
  }

  String _titleCase(String value) {
    return value.substring(0, 1).toUpperCase() + value.substring(1);
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(label)),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
