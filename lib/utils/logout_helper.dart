import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleLogout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  // Remove all stored keys
  await prefs.remove('name');
  await prefs.remove('nameExpiry');
  await prefs.remove('phone');
  await prefs.remove('phoneExpiry');
  await prefs.remove('user_mobile');
  await prefs.remove('user_token');
  await prefs.remove('auth_token');
  await prefs.remove('login_time');

  // Or clear everything (if you're okay with removing all keys)
  // await prefs.clear();

  // Navigate to login screen and remove all previous routes
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}
