import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fishpond/misc/app_theme.dart';
import 'package:fishpond/providers/auth.dart';
import 'package:fishpond/providers/notification.dart';
import 'package:fishpond/screens/auth/login_screen.dart';
import 'package:fishpond/screens/home.dart';
import 'package:fishpond/utilities/environment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background message: ${message.notification?.title}");
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? token = preferences.getString(TOKEN);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider())
      ],
      child: FishPond(token: token),
    )
  );
}

class FishPond extends StatelessWidget {
  final String? token;
  const FishPond({super.key, this.token});



  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fish Pond',
      theme: theme,
      routes: {
        LoginScreen.routeName: (_) =>  LoginScreen(),
        HomeScreen.routeName: (_) => const HomeScreen()
      },
      // home: LoginScreen(),
      home: token == null ?  LoginScreen(): const HomeScreen()
    );
  }
}
