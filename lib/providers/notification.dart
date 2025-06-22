import 'dart:convert' as convert;

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../utilities/environment.dart';

class NotificationProvider with ChangeNotifier {

  late List _notifications = [];

  get getNotifications => _notifications;

  Future<bool> getNotification() async {
    try {
      final url = Uri.parse('${API_URL}notifications/get-recent');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${await getToken()}',
      });

      if (response.statusCode == 200) {
        final jsonBody = convert.jsonDecode(response.body);
        print(jsonBody);

        if (jsonBody is Map && jsonBody['data'] is List) {
          _notifications = jsonBody['data']; // ✅ Correct assignment
        } else {
          _notifications = [];
        }

        notifyListeners();
        return true;
      }

      _notifications = [];
      notifyListeners();
      return false;
    } catch (error) {
      _notifications = [];
      notifyListeners();
      rethrow;
    }
  }




  Future submitNotificationToken(String token) async {
    try {
      final url = Uri.parse('${API_URL}notifications/save-token');
      final response = await http.post(url, body: {
        'fcm_token': token
      }, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      });

      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
      }
      notifyListeners();
      return false;
    } catch(error) {
      rethrow;
    }
  }

}