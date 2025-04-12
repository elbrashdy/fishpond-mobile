import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const String routeName = '/history';

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
            child: Text("History"),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
