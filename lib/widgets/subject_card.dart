import 'package:flutter/material.dart';
import '../models/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const SubjectCard({super.key, required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = subject.progress;
    final done = subject.isFullyCompleted;

    return Card(
      color: scheme.surfaceContainerHigh,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: scheme.primary.withOpacity(0.12),
                child: Text(subject.icon, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            subject.nameBn,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15.5),
                          ),
                        ),
                        if (done) const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text('🏆', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${subject.completedCount}/${subject.topics.length} টপিক · ${subject.totalMarks} নম্বর',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: scheme.primary.withOpacity(0.12),
                        valueColor: AlwaysStoppedAnimation(done ? Colors.amber.shade700 : scheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
