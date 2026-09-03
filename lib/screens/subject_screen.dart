import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../providers/progress_provider.dart';
import '../widgets/topic_tile.dart';
import 'topic_detail_sheet.dart';

class SubjectScreen extends StatefulWidget {
  final String subjectId;
  const SubjectScreen({super.key, required this.subjectId});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  String _query = '';
  bool _onlyPending = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();
    final Subject subject = provider.subjects.firstWhere((s) => s.id == widget.subjectId);

    final filtered = subject.topics.where((t) {
      final matchesQuery = _query.isEmpty || t.title.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = !_onlyPending || !t.isCompleted;
      return matchesQuery && matchesFilter;
    }).toList();

    final wasComplete = subject.isFullyCompleted;

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.nameBn),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: subject.progress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${subject.completedCount}/${subject.topics.length} সম্পন্ন'),
                    Text('${subject.earnedMarks}/${subject.totalMarks} নম্বর'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'টপিক খুঁজুন...',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('বাকি আছে'),
                  selected: _onlyPending,
                  onSelected: (v) => setState(() => _onlyPending = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('কোনো টপিক পাওয়া যায়নি'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final topic = filtered[i];
                      return TopicTile(
                        topic: topic,
                        onCheckToggle: () async {
                          await provider.toggleTopic(topic.id);
                          if (!wasComplete && subject.isFullyCompleted && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🎉 অভিনন্দন! "${subject.nameBn}" সম্পূর্ণ শেষ করেছেন!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        onOpenDetail: () => showTopicDetailSheet(context, topic),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
