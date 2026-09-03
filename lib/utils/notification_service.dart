import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'bcstracker_channel';
  static const String _channelName = 'BCSTracker';
  static const String _channelDesc =
      'BCSTracker study reminders and progress updates';

  /// Call once at app startup (in main()).
  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create the notification channel (Android 8+)
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.defaultImportance,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Request POST_NOTIFICATIONS permission (Android 13+).
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission() ?? false;
    return granted;
  }

  /// Show an instant notification (e.g. after resetting progress).
  Future<void> showInstant({
    required int id,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      ),
    );
    await _plugin.show(id, title, body, details);
  }

  /// Show a study-progress notification with the current completion %.
  Future<void> showProgressUpdate(double percentComplete) async {
    final pct = (percentComplete * 100).toStringAsFixed(1);
    await showInstant(
      id: 1001,
      title: 'BCSTracker — অগ্রগতি আপডেট',
      body: 'আপনি BCS সিলেবাসের $pct% সম্পন্ন করেছেন! চালিয়ে যান',
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    // Navigate or handle tap here if needed.
  }
}
