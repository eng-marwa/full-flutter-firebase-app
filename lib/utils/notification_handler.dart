import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:g1d_firebase/main.dart';
import 'package:g1d_firebase/utils/context_extension.dart';

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage remoteMessage) {
        print('onMessage-> A new message arrived');
        print(remoteMessage.notification?.title);
        print(remoteMessage.notification?.body);
        print(remoteMessage.data);
        showNotification(remoteMessage);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage remoteMessage) {
        print('onMessageOpenedApp-> A new message arrived');
        print(remoteMessage.notification?.title);
        print(remoteMessage.notification?.body);
        print(remoteMessage.data);
        showNotification(remoteMessage);
      },
    );
  }

  static void handleBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }

  static Future<void> showNotification(RemoteMessage remoteMessage) async {
    //Android Initialization

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('app_icon');
    //Ios Initialization
    DarwinInitializationSettings iOSInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);
    _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Tapped');
        if (remoteMessage.data['data'] != null) {
          navigateTo(remoteMessage.data['data']);
        }
      },
      onDidReceiveBackgroundNotificationResponse: _onTapBgNotification,
    );

    //Android Details
    // AndroidBitmap largeIcon = const FilePathAndroidBitmap();
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('g1d_channel_id', 'g1d_channel_title',
            priority: Priority.high,
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            autoCancel: true,
            enableLights: true);

    //IOS Details
    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);
    _plugin.show(remoteMessage.hashCode, remoteMessage.notification?.title,
        remoteMessage.notification?.body, notificationDetails);
  }

  static _onTapNotification(
      NotificationResponse details, RemoteMessage remoteMessage) {}

  static Future<void> handlePermission() async {
    FirebaseMessaging.instance.requestPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

void navigateTo(Object data) {
  BuildContext context = navigatorKey.currentContext!;
  context.navigateTo('/data', arguments: data);
}

Future<void> onBackgroundMessage(RemoteMessage message) async {
  print('onBackgroundMessage-> A new message arrived');
  GlobalNotificationHandler.remoteMessage = message;
  print(message.notification?.title);
  print(message.notification?.body);
  print(message.data);
}

void _onTapBgNotification(NotificationResponse details) {
  print('Notification Tapped');
  RemoteMessage remoteMessage = GlobalNotificationHandler.remoteMessage!;
  if (remoteMessage.data['data'] != null) {
    navigateTo(remoteMessage.data['data']);
  }
}

class GlobalNotificationHandler {
  static RemoteMessage? remoteMessage;
}
