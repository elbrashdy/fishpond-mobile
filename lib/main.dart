import 'package:fishpond/misc/app_theme.dart';
import 'package:fishpond/screens/auth/login_screen.dart';
import 'package:fishpond/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FishPond());
}

class FishPond extends StatelessWidget {
  const FishPond({super.key});



  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fish Pond',
      theme: theme,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        HomeScreen.routeName: (_) => const HomeScreen()
      },
      home: LoginScreen(),
    );
  }
}
