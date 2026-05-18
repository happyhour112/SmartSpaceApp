import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    await requestNotificationPermission();

    _isInitialized = true;
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isDenied || status.isRestricted) {
      await Permission.notification.request();
    }
  }

  Future<void> showHighTemperatureAlert({
    required String deviceName,
    required double temperature,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'iot_alert_channel',
      'IoT Alerts',
      channelDescription: 'Notifications for IoT sensor warnings',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'High Temperature Alert',
      '$deviceName detected ${temperature.toStringAsFixed(1)} °C',
      notificationDetails,
    );
  }
}
