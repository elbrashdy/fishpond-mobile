import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/environment.dart';



class AuthProvider with ChangeNotifier {
  final loginUrl = Uri.parse('${API_URL}auth/login');
  final signUpUrl = Uri.parse('${API_URL}register');
  final changePwdUrl = Uri.parse('${API_URL}change-password');


  Future<bool> login(String email, String password) async {
    final response = await http.post(loginUrl, body: {
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json',
    });


    if (response.statusCode == 200) {
      var jsonBody = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var token = jsonBody['data']['token'];
      var user = jsonBody['data']['user'];
      await saveToken(token, user);
      notifyListeners();
      return true;
    }

    if (response.statusCode == 422) {
      notifyListeners();
      return false;
    }

    return false;
  }


  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN);
  }

  saveToken(String token, user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN, token);
    await prefs.setString("name", user['name']);
    await prefs.setString("email", user['email']);
  }

  logout() async {
    try {
      final url = Uri.parse('${API_URL}auth/logout');
      final response = await http.post(url, headers: {'Authorization': 'Bearer ${await getToken()}'});
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        notifyListeners();
        return true;
      }

      notifyListeners();
      return false;
    } catch(error) {
      rethrow;
    }
  }

  Future<bool> changePassword(String currentPassword, String password, String passwordConfirmation) async {
    final response = await http.post(changePwdUrl, body: {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': passwordConfirmation
    }, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await getToken()}'
    });


    if (response.statusCode == 200) {
      return true;
    }

    if (response.statusCode == 422) {
      return false;
    }

    return false;
  }

}