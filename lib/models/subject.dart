import 'topic.dart';

class Subject {
  final String id;
  final String nameBn;
  final String nameEn;
  final int totalMarks;
  final String icon; // emoji used as a lightweight icon, no asset needed
  final List<Topic> topics;

  Subject({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.totalMarks,
    required this.icon,
    required this.topics,
  });

  int get completedCount => topics.where((t) => t.isCompleted).length;

  double get progress => topics.isEmpty ? 0 : completedCount / topics.length;

  int get earnedMarks {
    if (topics.isEmpty) return 0;
    final marksPerTopic = totalMarks / topics.length;
    return (completedCount * marksPerTopic).round();
  }

  bool get isFullyCompleted => topics.isNotEmpty && completedCount == topics.length;
}
