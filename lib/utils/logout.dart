import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/controller/schemes_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/UserController.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  Future<void> handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
      // Remove all stored keys
  await prefs.remove('name');
  await prefs.remove('username');
  await prefs.remove('role');
  await prefs.remove('nameExpiry');
  await prefs.remove('phone');
  await prefs.remove('user_mobile');
  await prefs.remove('user_token');
  await prefs.remove('auth_token');
  await prefs.remove('login_time');
  await prefs.remove('user_id');
  await prefs.remove('is_profile_complete');

    // ✅ Clear controller memory state
    final userController = Get.find<UserController>();
    userController.clearUserData();

 // ✅ Clear controller memory state
    final schemeController = Get.find<SchemeController>();
schemeController.isSchemeDataFetched.value = false;


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout successful'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 800));
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleLogout(context);
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
