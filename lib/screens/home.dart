import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fishpond/providers/notification.dart';
import 'package:fishpond/screens/history_screen.dart';
import 'package:fishpond/screens/landing_screen.dart';
import 'package:fishpond/screens/notification_screen.dart';
import 'package:fishpond/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {

  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? fcmToken = '';
  String notificationMessage = 'Waiting for alert...';

  @override
  void initState() {
    super.initState();
    setupFCM();
  }

  Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission on iOS
    await messaging.requestPermission();

    // Get FCM token
    fcmToken = await messaging.getToken();

    Provider.of<NotificationProvider>(context, listen: false).submitNotificationToken(fcmToken!).then(
        (onValue) => {}
    );

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notificationMessage = message.notification!.body ?? 'New Alert!';
        });
      }
    });
  }

  int _selectedIndex = 0;

  final List<Widget> pages = [
    const LandingScreen(),
    const HistoryScreen(),
    const NotificationScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // ignore: prefer_const_literals_to_create_immutables
        items: <BottomNavigationBarItem>[
          // ignore: prefer_const_constructors
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: "History"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notification"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile")
        ],
      ),
    );
  }
}

