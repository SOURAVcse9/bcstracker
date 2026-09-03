import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/syllabus_data.dart';
import '../models/subject.dart';

/// Central app state. Persists ONLY to the device's local storage
/// via SharedPreferences (no database, no network, fully offline).
class ProgressProvider extends ChangeNotifier {
  static const _progressKey = 'bcs_progress_v1';
  static const _examDateKey = 'bcs_exam_date_v1';
  static const _themeKey = 'bcs_theme_mode_v1';
  static const _nameKey = 'bcs_user_name_v1';

  late SharedPreferences _prefs;
  List<Subject> subjects = buildSyllabus();
  DateTime? examDate;
  ThemeMode themeMode = ThemeMode.system;
  String userName = '';
  bool _loaded = false;
  bool get loaded => _loaded;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadProgress();
    _loadExamDate();
    _loadTheme();
    userName = _prefs.getString(_nameKey) ?? '';
    _loaded = true;
    notifyListeners();
  }

  // ---------- Persistence ----------

  void _loadProgress() {
    final raw = _prefs.getString(_progressKey);
    if (raw == null) return;
    final Map<String, dynamic> data = jsonDecode(raw);
    for (final subject in subjects) {
      for (final topic in subject.topics) {
        if (data.containsKey(topic.id)) {
          topic.applyProgressJson(Map<String, dynamic>.from(data[topic.id]));
        }
      }
    }
  }

  Future<void> _saveProgress() async {
    final Map<String, dynamic> data = {};
    for (final subject in subjects) {
      for (final topic in subject.topics) {
        data[topic.id] = topic.toProgressJson();
      }
    }
    await _prefs.setString(_progressKey, jsonEncode(data));
  }

  void _loadExamDate() {
    final raw = _prefs.getString(_examDateKey);
    if (raw != null) examDate = DateTime.tryParse(raw);
  }

  Future<void> setExamDate(DateTime? date) async {
    examDate = date;
    if (date == null) {
      await _prefs.remove(_examDateKey);
    } else {
      await _prefs.setString(_examDateKey, date.toIso8601String());
    }
    notifyListeners();
  }

  void _loadTheme() {
    final v = _prefs.getString(_themeKey);
    themeMode = switch (v) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    await _prefs.setString(_themeKey, mode.name);
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    userName = name;
    await _prefs.setString(_nameKey, name);
    notifyListeners();
  }

  // ---------- Topic actions ----------

  Future<void> toggleTopic(String topicId) async {
    final topic = _findTopic(topicId);
    if (topic == null) return;
    if (topic.isCompleted) {
      topic.isCompleted = false;
      topic.completedDate = null;
    } else {
      topic.startDate ??= DateTime.now();
      topic.isCompleted = true;
      topic.completedDate = DateTime.now();
    }
    await _saveProgress();
    notifyListeners();
  }

  Future<void> markStarted(String topicId) async {
    final topic = _findTopic(topicId);
    if (topic == null) return;
    topic.startDate ??= DateTime.now();
    await _saveProgress();
    notifyListeners();
  }

  Future<void> updateTopicDates(String topicId, {DateTime? start, DateTime? completed}) async {
    final topic = _findTopic(topicId);
    if (topic == null) return;
    topic.startDate = start;
    topic.completedDate = completed;
    if (completed != null) topic.isCompleted = true;
    await _saveProgress();
    notifyListeners();
  }

  Future<void> updateNote(String topicId, String note) async {
    final topic = _findTopic(topicId);
    if (topic == null) return;
    topic.note = note;
    await _saveProgress();
    notifyListeners();
  }

  dynamic _findTopic(String topicId) {
    for (final subject in subjects) {
      for (final topic in subject.topics) {
        if (topic.id == topicId) return topic;
      }
    }
    return null;
  }

  Future<void> resetAllProgress() async {
    for (final subject in subjects) {
      for (final topic in subject.topics) {
        topic.isCompleted = false;
        topic.startDate = null;
        topic.completedDate = null;
        topic.note = '';
      }
    }
    await _saveProgress();
    notifyListeners();
  }

  // ---------- Aggregate stats ----------

  int get totalTopics => subjects.fold(0, (sum, s) => sum + s.topics.length);

  int get completedTopics => subjects.fold(0, (sum, s) => sum + s.completedCount);

  double get overallProgress => totalTopics == 0 ? 0 : completedTopics / totalTopics;

  int get totalMarks => subjects.fold(0, (sum, s) => sum + s.totalMarks);

  int get earnedMarks => subjects.fold(0, (sum, s) => sum + s.earnedMarks);

  /// Consecutive-day study streak, counting backward from today,
  /// based on distinct completion dates across all topics.
  int get studyStreak {
    final days = <DateTime>{};
    for (final subject in subjects) {
      for (final topic in subject.topics) {
        final d = topic.completedDate;
        if (d != null) {
          days.add(DateTime(d.year, d.month, d.day));
        }
      }
    }
    if (days.isEmpty) return 0;
    int streak = 0;
    DateTime cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int? get daysUntilExam {
    if (examDate == null) return null;
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    final e = DateTime(examDate!.year, examDate!.month, examDate!.day);
    return e.difference(t).inDays;
  }
}
