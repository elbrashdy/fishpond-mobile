import 'dart:convert' as convert;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../utilities/environment.dart';

class ReadingProvider with ChangeNotifier {

  late List _readings = [];
  get getReadings => _readings;

  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> get history => _history;

  Future<bool> getReading() async {
    try {
      final url = Uri.parse('${API_URL}readings');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${await getToken()}',
      });

      if (response.statusCode == 200) {
        final jsonBody = convert.jsonDecode(response.body);

        if (jsonBody is Map && jsonBody['data'] is List) {
          _readings = jsonBody['data'];
        } else {
          _readings = [];
        }

        notifyListeners();
        return true;
      }

      _readings = [];
      notifyListeners();
      return false;
    } catch (error) {
      _readings = [];
      notifyListeners();
      rethrow;
    }
  }

  void addNewReading(Map<String, dynamic> reading) {
    _readings.add(reading);
    notifyListeners();
  }



  Future<bool> fetchWeeklyHistory() async {
    try {
      final url = Uri.parse('${API_URL}readings/history');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${await getToken()}',
      });

      if (response.statusCode == 200) {

        final jsonBody = convert.json.decode(response.body);

        if (jsonBody is Map && jsonBody['data'] is List) {
          _history = List<Map<String, dynamic>>.from(jsonBody['data']);
        }

        notifyListeners();
        return true;
      } else {
        _history = [];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _history = [];
      notifyListeners();
      rethrow;
    }
  }

}