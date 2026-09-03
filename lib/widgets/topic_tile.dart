import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../utils/date_utils.dart';

class TopicTile extends StatelessWidget {
  final Topic topic;
  final VoidCallback onCheckToggle;
  final VoidCallback onOpenDetail;

  const TopicTile({
    super.key,
    required this.topic,
    required this.onCheckToggle,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: topic.isCompleted ? scheme.primary.withOpacity(0.07) : scheme.surfaceContainerHigh,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onOpenDetail,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            children: [
              Checkbox(
                value: topic.isCompleted,
                onChanged: (_) => onCheckToggle(),
                shape: const CircleBorder(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      topic.title,
                      style: TextStyle(
                        fontSize: 14.5,
                        decoration: topic.isCompleted ? TextDecoration.lineThrough : null,
                        color: topic.isCompleted ? scheme.onSurface.withOpacity(0.55) : null,
                      ),
                    ),
                    if (topic.startDate != null || topic.completedDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          'শুরু: ${formatDate(topic.startDate)}   •   শেষ: ${formatDate(topic.completedDate)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11.5),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${topic.marks}#', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
