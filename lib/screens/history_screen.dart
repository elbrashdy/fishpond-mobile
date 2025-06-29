import 'package:fishpond/providers/reading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    await Provider.of<ReadingProvider>(context, listen: false).fetchWeeklyHistory();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<ReadingProvider>(context).history;

    return Scaffold(
      appBar: AppBar(title: const Text("Weekly History", style: TextStyle(color: Colors.white),)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
          ? const Center(child: Text("No history available"))
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text("Week starting ${item['week']}"),
              subtitle: Text("Avg Temp: ${item['average_temperature'].toStringAsFixed(1)} °C\n"
                  "Avg pH: ${item['average_ph'].toStringAsFixed(2)}"),
            ),
          );
        },
      ),
    );
  }
}
