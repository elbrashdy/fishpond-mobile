import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reading.dart';
import 'monitor.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReadings();
  }

  Future<void> loadReadings() async {
    final readingProvider = Provider.of<ReadingProvider>(context, listen: false);
    await readingProvider.getReading();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Real time monitoring",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
        body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : MonitoringDashboard()
    );
  }
}

