import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/environment.dart';



class AuthProvider with ChangeNotifier {
  final loginUrl = Uri.parse('${API_URL}auth/login');
  final signUpUrl = Uri.parse('${API_URL}register');
  final changePwdUrl = Uri.parse('${API_URL}password-reset');
  final requestCodeUrl = Uri.parse('${API_URL}request-password-code');
  final confirmCodeUrl = Uri.parse('${API_URL}check-code');
  final resetPasswordUrl = Uri.parse('${API_URL}create-new-password');


  Future<bool> login(String email, String password) async {
    final response = await http.post(loginUrl, body: {
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json',
    });


    print("Nassor test: object");

    if (response.statusCode == 200) {
      var jsonBody = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var token = jsonBody['data']['token'];
      var user = jsonBody['data']['user'];
      print(token);
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











  Future<bool> signup(
      String name,
      String email,
      String password,
      ) async {
    final response = await http.post(signUpUrl, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'role': 'employee'
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 201) {
      var jsonBody = convert.jsonDecode(response.body) as Map<String, dynamic>;

      var token = jsonBody['token'];
      var user = jsonBody['data'];
      await saveToken(token, user);
      notifyListeners();
      return true;
    }



    if (response.statusCode == 422) {
      notifyListeners();
      return false;
    }

    notifyListeners();
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

      print(response.statusCode);
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

  Future<bool> changePassword(String currentPassword, String password) async {
    final response = await http.put(changePwdUrl, body: {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': password
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

  Future<bool> requestCode(email) async {
    final response = await http.put(requestCodeUrl, body: {
      'email': email,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> confirmCode(email, code) async {
    final response = await http.post(confirmCodeUrl, body: {
      'email': email,
      'code': code.toString()
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> resetPassword(email, code, password) async {
    final response = await http.put(resetPasswordUrl, body: {
      'email': email,
      'code': code.toString(),
      'password': password,
      'password_confirmation': password
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    }

    return false;
  }
}