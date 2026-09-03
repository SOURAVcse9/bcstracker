import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../providers/progress_provider.dart';
import '../utils/date_utils.dart';

Future<void> showTopicDetailSheet(BuildContext context, Topic topic) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _TopicDetailSheet(topic: topic),
  );
}

class _TopicDetailSheet extends StatefulWidget {
  final Topic topic;
  const _TopicDetailSheet({required this.topic});

  @override
  State<_TopicDetailSheet> createState() => _TopicDetailSheetState();
}

class _TopicDetailSheetState extends State<_TopicDetailSheet> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.topic.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, {required bool isStart}) async {
    final provider = context.read<ProgressProvider>();
    final topic = widget.topic;
    final initial = (isStart ? topic.startDate : topic.completedDate) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        topic.startDate = picked;
      } else {
        topic.completedDate = picked;
        topic.isCompleted = true;
      }
    });
    await provider.updateTopicDates(topic.id, start: topic.startDate, completed: topic.completedDate);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();
    final topic = widget.topic;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(topic.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('মানবণ্টন: ${topic.marks}', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickDate(context, isStart: true),
                  icon: const Icon(Icons.play_circle_outline),
                  label: Text('শুরু: ${formatDate(topic.startDate)}'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickDate(context, isStart: false),
                  icon: const Icon(Icons.flag_outlined),
                  label: Text('শেষ: ${formatDate(topic.completedDate)}'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (topic.startDate != null && topic.completedDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '⏱ ${formatDuration(topic.startDate, topic.completedDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 18),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('সম্পন্ন হয়েছে'),
            value: topic.isCompleted,
            onChanged: (_) async {
              await provider.toggleTopic(topic.id);
              setState(() {});
            },
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'নোট (ঐচ্ছিক)',
              hintText: 'এই টপিক নিয়ে নিজের নোট লিখুন...',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => provider.updateNote(topic.id, v),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
