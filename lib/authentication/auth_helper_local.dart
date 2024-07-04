import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelperLocal {
  static Future<String?> getUserEmail() async {
    debugPrint(
        'getting user email from shared preferences : AuthHelperLocal.getUserEmail()\n');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  static Future<void> setUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint('setting user email = AuthHelperLocal.setUserEmail()');
    await prefs.setString('user_email', email);
  }

  static Future<void> removeUserEmail() async {
    debugPrint(
        'removing user email from shared preferences : AuthHelperLocal.removeUserEmail()\n');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }
}
