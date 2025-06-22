

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    NotificationSettings settings = await _fcm.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Get token
      String? token = await _fcm.getToken();
      print('FCM Token: $token');

      // Save this token to your Laravel backend

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received message: ${message.notification?.title}');
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Message clicked!');
      });
    }
  }
}
