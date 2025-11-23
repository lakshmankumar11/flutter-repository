import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gold_purchase_app/admin/admin_main_dashboard.dart';
import 'package:gold_purchase_app/utils/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../config/constantsApiBaseUrl.dart';
import './signup_page.dart';

class PinVerificationPage extends StatefulWidget {
  @override
  _PinVerificationPageState createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> {
  final TextEditingController _pinController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

Future<void> _verifyPin() async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  final enteredPin = _pinController.text.trim();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final role = prefs.getString('role'); // 👈 get role

  if (token == null || enteredPin.isEmpty) {
    setState(() {
      _errorMessage = 'Token or PIN missing';
      _isLoading = false;
    });
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/login-with-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'pin': enteredPin}),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      // ✅ Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: SizedBox.expand(
            child: Container(
              color: const Color.fromARGB(255, 44, 44, 44),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/animations/lock3.json', height: 200),
                    const SizedBox(height: 12),
                    const Text(
                      'Login successful!',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 3));
      Navigator.pop(context); // Close dialog

      // ✅ Navigate based on role
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminMainDashboard()),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }

    } else {
      final res = jsonDecode(response.body);
      setState(() {
        _errorMessage = res['message'] ?? res['error'] ?? 'PIN verification failed';
      });
    }
  } catch (e) {
  
    setState(() {
      _errorMessage = 'Something went wrong. Please try again.';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}




  // Future<void> _logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   Navigator.pushReplacementNamed(context, '/login');
  // }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.amber;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Enter PIN'),
      ),
body: LayoutBuilder(
  builder: (context, constraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Lottie animation (uncomment this if needed)
                // Animate(
                //   effects: [FadeEffect(duration: 700.ms)],
                //   child: Lottie.asset(
                //     'assets/animations/lock2.json',
                //     height: 150,
                //   ),
                // ),

                const SizedBox(height: 8),
                Text(
                  'Enter your 4-digit PIN',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ).animate().slideY(begin: 1).fadeIn(duration: 500.ms),
                const SizedBox(height: 24),

                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.amber.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    labelText: 'PIN',
                    prefixIcon: const Icon(Icons.lock_outline),
                    errorText: _errorMessage,
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    minimumSize: const Size(double.infinity, 48),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _verifyPin,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify PIN',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ).animate().slideY(begin: 0.5).fadeIn(delay: 400.ms),
   
const SizedBox(height: 16),
                // TextButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => LogoutPage()),
                //     );
                //   },
                //   child: const Text(
                //     'Logout?',
                //     style: TextStyle(fontWeight: FontWeight.w600),
                //   ),
                // ).animate().fadeIn(delay: 600.ms),
   
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupPage(isForgotPin: true)),
                    );
                  },
                  child: const Text(
                    'Forgot PIN?',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ).animate().fadeIn(delay: 600.ms),

              ],

              
            ),
          ),
        ),
      ),
    );
  },
),

    );
  }
}
