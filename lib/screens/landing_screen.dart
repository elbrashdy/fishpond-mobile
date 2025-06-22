import 'package:fishpond/screens/monitor.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 35),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: MonitoringDashboard(),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
