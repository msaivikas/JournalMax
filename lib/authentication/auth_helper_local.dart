import 'package:shared_preferences/shared_preferences.dart';

class AuthHelperLocal {
  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  static Future<void> setUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  static Future<void> removeUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }
}
