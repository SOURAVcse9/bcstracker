class Topic {
  final String id;
  final String title;
  final String? details;
  final int marks;
  bool isCompleted;
  DateTime? startDate;
  DateTime? completedDate;
  String note;

  Topic({
    required this.id,
    required this.title,
    this.details,
    this.marks = 0,
    this.isCompleted = false,
    this.startDate,
    this.completedDate,
    this.note = '',
  });

  Map<String, dynamic> toProgressJson() => {
        'isCompleted': isCompleted,
        'startDate': startDate?.toIso8601String(),
        'completedDate': completedDate?.toIso8601String(),
        'note': note,
      };

  void applyProgressJson(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'] ?? false;
    startDate = json['startDate'] != null ? DateTime.parse(json['startDate']) : null;
    completedDate = json['completedDate'] != null ? DateTime.parse(json['completedDate']) : null;
    note = json['note'] ?? '';
  }
}
