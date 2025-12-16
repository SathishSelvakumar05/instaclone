import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background Message: ${message.notification?.title}');
}

class PushNotificationService {
  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    print(' Permission: ${settings.authorizationStatus}');

    // Token
    String? token = await messaging.getToken();
    print('FCΜ Token: $token');

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(' Foreground Message: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("App opened by notification");
    });
  }
}
