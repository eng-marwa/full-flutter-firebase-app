import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:g1d_firebase/utils/notification_handler.dart';
import 'package:g1d_firebase/view_data.dart';

import 'firebase_options.dart';
import 'home.dart';
import 'login.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      //register in backend
      print('Token: $token');
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      print('Token: $event');
    });
    NotificationHandler.handlePermission();
  } on FirebaseException catch (e) {
    print(e);
  }
  NotificationHandler.handleForegroundMessage();
  NotificationHandler.handleBackgroundMessage();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/data': (context) => ViewData(),
      },
    );
  }
}
