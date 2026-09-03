import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/progress_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();
    final scheme = Theme.of(context).colorScheme;
    final palette = [
      scheme.primary,
      scheme.secondary,
      scheme.tertiary,
      Colors.orange,
      Colors.teal,
      Colors.purple,
      Colors.indigo,
      Colors.brown,
      Colors.pink,
      Colors.blueGrey,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('পরিসংখ্যান')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      icon: Icons.local_fire_department,
                      color: Colors.deepOrange,
                      label: 'স্ট্রিক',
                      value: '${provider.studyStreak} দিন',
                    ),
                  ),
                  Expanded(
                    child: _StatBox(
                      icon: Icons.check_circle,
                      color: Colors.green,
                      label: 'সম্পন্ন টপিক',
                      value: '${provider.completedTopics}/${provider.totalTopics}',
                    ),
                  ),
                  Expanded(
                    child: _StatBox(
                      icon: Icons.star,
                      color: Colors.amber.shade800,
                      label: 'আনুমানিক নম্বর',
                      value: '${provider.earnedMarks}/${provider.totalMarks}',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('বিষয়ভিত্তিক অগ্রগতি', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 20, 12),
              child: SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    maxY: 1,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= provider.subjects.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(provider.subjects[i].icon, style: const TextStyle(fontSize: 14)),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (int i = 0; i < provider.subjects.length; i++)
                        BarChartGroupData(x: i, barRods: [
                          BarChartRodData(
                            toY: provider.subjects[i].progress,
                            color: palette[i % palette.length],
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('বিষয় তালিকা', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...List.generate(provider.subjects.length, (i) {
            final s = provider.subjects[i];
            return ListTile(
              leading: CircleAvatar(backgroundColor: palette[i % palette.length].withOpacity(0.15), child: Text(s.icon)),
              title: Text(s.nameBn),
              subtitle: Text('${s.completedCount}/${s.topics.length} টপিক · ${s.earnedMarks}/${s.totalMarks} নম্বর'),
              trailing: Text('${(s.progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _StatBox({required this.icon, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center),
        Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}
