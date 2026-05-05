import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/mental_insight.dart';
import '../services/mental_health_api.dart';
import '../widgets/metric_tile.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final _api = MentalHealthApi();
  late Future<MentalInsight> _insightFuture;

  @override
  void initState() {
    super.initState();
    _insightFuture = _api.analyze();
  }

  void _loadInsights() {
    setState(() {
      _insightFuture = _api.analyze();
    });
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MentalInsight>(
      future: _insightFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.insights_outlined, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _loadInsights,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        final insight = snapshot.data!;
        final generatedAt = DateFormat('MMM d, yyyy - HH:mm').format(
          insight.generatedAt,
        );

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Mental health insights',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh insights',
                  onPressed: _loadInsights,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('Generated $generatedAt'),
            const SizedBox(height: 18),
            Row(
              children: [
                MetricTile(
                  label: 'Avg stress',
                  value: insight.averageStressLevel.toStringAsFixed(1),
                  icon: Icons.speed_outlined,
                ),
                const SizedBox(width: 10),
                MetricTile(
                  label: 'Avg sleep',
                  value: '${insight.averageSleepHours.toStringAsFixed(1)} h',
                  icon: Icons.bedtime_outlined,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                MetricTile(
                  label: 'Entries',
                  value: insight.totalEntries.toString(),
                  icon: Icons.list_alt_outlined,
                ),
                const SizedBox(width: 10),
                MetricTile(
                  label: 'Negative recent',
                  value: insight.recentNegativeMoodCount.toString(),
                  icon: Icons.trending_down_outlined,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(insight.summary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...insight.messages.map(
              (message) => Card(
                child: ListTile(
                  leading: const Icon(Icons.tips_and_updates_outlined),
                  title: Text(message),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
