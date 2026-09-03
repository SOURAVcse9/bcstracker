import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) return '—';
  return DateFormat('d MMM yyyy').format(date);
}

String formatDuration(DateTime? start, DateTime? end) {
  if (start == null || end == null) return '—';
  final days = end.difference(start).inDays;
  if (days <= 0) return 'একই দিনে সম্পন্ন';
  return '$days দিন লেগেছে';
}
