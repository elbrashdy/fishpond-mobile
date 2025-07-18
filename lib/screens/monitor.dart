import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../providers/reading.dart';

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
          // For development
          // print("Connection: $previousState → $currentState");
        },
        onError: (message, code, exception) {
          // for development
          // print("Pusher error: $message ($code): $exception");
        },
        onEvent: (event) {

          try {
            final decoded = jsonDecode(event.data ?? '{}');
            final reading = decoded['reading'];

            if (reading != null) {
              setState(() {
                temperature = reading['temperature'].toString();

                final phRaw = reading['ph_value'];
                double parsedPh = 0.0;

                if (phRaw is int) {
                  parsedPh = phRaw.toDouble();
                } else if (phRaw is double) {
                  parsedPh = phRaw;
                } else if (phRaw is String) {
                  parsedPh = double.tryParse(phRaw) ?? 0.0;
                }

                ph_value = parsedPh;
                ph = parsedPh.toStringAsFixed(2);
              });

              final readingProvider = Provider.of<ReadingProvider>(context, listen: false);
              readingProvider.addNewReading({
                'temperature': reading['temperature'],
                'ph_value': reading['ph_value'],
                'created_at': reading['created_at'] ?? DateTime.now().toIso8601String(),
              });
            }
          } catch (e) {
            // for development
           // print("Error parsing event data: $e");
          }
        },
      );

      await _pusher.subscribe(channelName: 'sensor-channel');
      await _pusher.connect();
    } catch (e) {
      // for development
      // print("Pusher init error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final readings = Provider.of<ReadingProvider>(context).getReadings;

    return SingleChildScrollView(
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
                      Text(temperature != '--'
                          ? temperature
                          : (readings.isNotEmpty ? readings.last['temperature'].toString() : '--'),
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                              value: ph_value != 0.0
                                  ? (ph_value / 14)
                                  : (readings.isNotEmpty ? readings.last['ph_value'] / 14 : 0.0),
                              strokeWidth: 6,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          Text(ph != '--'
                              ? ph
                              : (readings.isNotEmpty ? readings.last['ph_value'].toString() : '--'),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          SizedBox(height: 300, child: TemperatureChart(readings: readings,)),
          const SizedBox(height: 24),
          const Text("Real-Time pH Level Monitoring with Thresholds", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 300, child: PHChart(readings: readings,)),
        ],
      ),
    );
  }
}


class TemperatureChart extends StatelessWidget {
  final List readings;
  const TemperatureChart({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    final spots = readings.asMap().entries.map<FlSpot>((entry) {
      final i = entry.key.toDouble();
      final temp = entry.value['temperature'].toDouble();
      return FlSpot(i, temp);
    }).toList();

    return LineChart(
      LineChartData(
        minY: 19,
        maxY: 100,
        titlesData: FlTitlesData(show: true),
        lineBarsData: [
          LineChartBarData(
            isCurved: false,
            spots: spots,
            color: Colors.orange,
            barWidth: 2,
            dotData: FlDotData(show: true),
          ),
        ],
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(y: 26, color: Colors.red, dashArray: [5, 5], strokeWidth: 2),
          HorizontalLine(y: 33, color: Colors.blue, dashArray: [5, 5], strokeWidth: 2),
        ]),
      ),
    );
  }
}

class PHChart extends StatelessWidget {
  final List readings;
  const PHChart({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    final spots = readings.asMap().entries.map<FlSpot>((entry) {
      final i = entry.key.toDouble();
      final ph = entry.value['ph_value'].toDouble();
      return FlSpot(i, ph);
    }).toList();

    return LineChart(
      LineChartData(
        minY: 4.5,
        maxY: 12,
        titlesData: FlTitlesData(show: true),
        lineBarsData: [
          LineChartBarData(
            isCurved: false,
            spots: spots,
            color: Colors.blue,
            barWidth: 2,
            dotData: FlDotData(show: true),
          ),
        ],
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(y: 9.3, color: Colors.red, dashArray: [5, 5], strokeWidth: 2),
          HorizontalLine(y: 6.5, color: Colors.green, dashArray: [5, 5], strokeWidth: 2),
        ]),
      ),
    );
  }
}


