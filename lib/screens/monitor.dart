import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:convert';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class MonitoringDashboard extends StatefulWidget {
  const MonitoringDashboard({super.key});

  @override
  State<MonitoringDashboard> createState() => _MonitoringDashboardState();
}

class _MonitoringDashboardState extends State<MonitoringDashboard> {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  String temperature = '--';
  String ph = '--';
  double ph_value = 0.0;

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
                ph_value = reading['ph_value'];
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
      appBar: AppBar(title: const Text("Home Page", style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.wb_sunny, size: 32, color: Colors.orange),
                        Text(temperature, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text("Temperature"),
                      ],
                    ),
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                value: ph_value / 14,
                                strokeWidth: 6,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                            Text(ph, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text("pH Level"),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Real-time Temperature Monitoring with Thresholds", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 200, child: TemperatureChart()),
            const SizedBox(height: 24),
            const Text("Real-Time pH Level Monitoring with Thresholds", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 200, child: PHChart()),
          ],
        ),
      ),
    );
  }
}

// Temperature Chart
class TemperatureChart extends StatelessWidget {
  const TemperatureChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 24,
        maxY: 30,
        titlesData: FlTitlesData(show: true),
        lineBarsData: [
          LineChartBarData(
            isCurved: false,
            spots: List.generate(30, (i) => FlSpot(i.toDouble(), 25 + (i % 6).toDouble())),
            color: Colors.orange,
            barWidth: 2,
            dotData: FlDotData(show: true),
          ),
        ],
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(y: 28, color: Colors.red, dashArray: [5, 5], strokeWidth: 2),
          HorizontalLine(y: 25, color: Colors.blue, dashArray: [5, 5], strokeWidth: 2),
        ]),
      ),
    );
  }
}

// pH Chart
class PHChart extends StatelessWidget {
  const PHChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 6.0,
        maxY: 8.5,
        titlesData: FlTitlesData(show: true),
        lineBarsData: [
          LineChartBarData(
            isCurved: false,
            spots: List.generate(24, (i) => FlSpot(i.toDouble(), 6.5 + ((i % 5) * 0.4))),
            color: Colors.blue,
            barWidth: 2,
            dotData: FlDotData(show: true),
          ),
        ],
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(y: 8.5, color: Colors.red, dashArray: [5, 5], strokeWidth: 2),
          HorizontalLine(y: 6.5, color: Colors.green, dashArray: [5, 5], strokeWidth: 2),
        ]),
      ),
    );
  }
}
