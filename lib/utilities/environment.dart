import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names
const API_URL = 'https://fyp.elbrashdy.co.tz/api/';
const TOKEN = 'fish_p';

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(TOKEN);
}
