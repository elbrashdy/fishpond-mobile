import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  String temperature = '--';
  String ph = '--';

  @override
  void initState() {
    super.initState();
    initPusher();
  }

  Future<void> initPusher() async {
    try {
      await _pusher.init(
        apiKey: '9a7cf274e517a02dcedb',
        cluster: 'ap2',
        onConnectionStateChange: (currentState, previousState) {
          print("Connection: $previousState → $currentState");
        },
        onError: (message, code, exception) {
          print("Pusher error: $message ($code): $exception");
        },
        onEvent: (event) {
          print("Received event: ${event.eventName}");
          print("Data: ${event.data}");

          // Parse the nested data from Laravel
          try {
            final decoded = jsonDecode(event.data ?? '{}');
            final reading = decoded['reading'];

            if (reading != null) {
              setState(() {
                temperature = reading['temperature'].toString();
                ph = reading['ph_value'].toString();
              });
            }
          } catch (e) {
            print("Error parsing event data: $e");
          }
        },
      );

      await _pusher.subscribe(channelName: 'sensor-channel');
      await _pusher.connect();
    } catch (e) {
      print("Pusher init error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensor Readings")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Temperature: $temperature °C', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('pH Value: $ph', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
