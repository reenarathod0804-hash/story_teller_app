import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String topicName = 'new_stories';

  static Future<void> initialize() async {
    // 1. Request Permission (Required for iOS & Android 13+)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
    }

    // Get and print device FCM Token (useful for direct device testing in Firebase Console)
    try {
      String? token = await _messaging.getToken();
      debugPrint('====================================');
      debugPrint('🔥 FCM Device Token: $token');
      debugPrint('====================================');
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }

    // 2. Setup Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. Initialize Local Notifications (For Foreground heads-up alerts)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'new_stories_channel',
      'New Stories',
      description: 'Notifications for new story releases',
      importance: Importance.max,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
    }

    await _localNotifications.initialize(settings: initSettings);

    // 4. Foreground Message Listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'new_stories_channel',
              'New Stories',
              channelDescription: 'Notifications for new story releases',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/launcher_icon',
            ),
          ),
        );
      }
    });

    // 5. Default Subscribe to the 'new_stories' Topic
    await subscribeToNewStories();
  }

  static Future<void> subscribeToNewStories() async {
    try {
      await _messaging.subscribeToTopic(topicName);
      debugPrint('Subscribed to $topicName topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  static Future<void> unsubscribeFromNewStories() async {
    try {
      await _messaging.unsubscribeFromTopic(topicName);
      debugPrint('Unsubscribed from $topicName topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }
}
