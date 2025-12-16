import 'dart:async';
import 'dart:math' as Importance;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//local notification
  static Future localInit() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Initialization
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
      },
    );

    // Check if the app was launched from a notification (when terminated)
    final NotificationAppLaunchDetails? details =
    await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
    }

    // Request notification permission for Android
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }



//simple Notification
  static Future showInstantNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    final bigTextStyleInformation = BigTextStyleInformation(
      body,
      contentTitle: title,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'your channel name',
        channelDescription: 'your channel description',
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: bigTextStyleInformation,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      id ?? 0, // Fallback ID in case null
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
