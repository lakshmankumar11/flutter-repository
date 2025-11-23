import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'SetPinPage.dart';
import '../config/constantsApiBaseUrl.dart';
import './resetPin/ResetPinPage.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phone;
  final bool isForgotPin;

  const OTPVerificationPage({
    super.key,
    required this.phone,
    this.isForgotPin = false,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final otpController = TextEditingController();
  bool isLoading = false;

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    final phone = widget.phone;

    if (otp.length != 4 && otp.length != 6) {
      showMessage("Enter valid OTP.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final verifyUrl = Uri.parse('${AppConstants.baseUrl}/auth/verify-otp');
      final verifyRes = await http.post(
        verifyUrl,
        headers: {
          'Content-Type': 'application/json',
          'mobile': phone, // <-- Header
        },
        body: jsonEncode({
          'otp': otp, // <-- Body
        }),
      );

      final resBody = jsonDecode(verifyRes.body);

if (verifyRes.statusCode == 200 && resBody['otpToken'] != null) {
  final token = resBody['otpToken'];

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_token', token);
  await prefs.setString('user_mobile', phone);

  showMessage("OTP Verified Successfully");

  // Navigate after short delay
  Future.delayed(const Duration(milliseconds: 300), () {
   Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => widget.isForgotPin ? const ResetPinPage() : const SetPinPage(),
  ),
);
;
  });
}

 else {
        final msg = resBody['message'] ?? 'OTP verification failed';
        showMessage(msg);
      }
    } catch (e) {
      showMessage("Something went wrong. Try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resendOtp() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');

    final url = Uri.parse('${AppConstants.baseUrl}/auth/send-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobile': widget.phone,
          if (name != null) 'username': name,
        }),
      );

      if (response.statusCode == 200) {
        showMessage("OTP resent successfully");
      } else {
        final resData = jsonDecode(response.body);
        String msg = resData['message'] ?? 'Failed to resend OTP';
        if (msg.contains('Too many requests')) {
          msg = 'You’ve requested OTP too frequently. Please wait a minute.';
        }
        showMessage(msg);
      }
    } catch (_) {
      showMessage("Network error. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("Enter the OTP sent to ${widget.phone}"),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'OTP',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : verifyOtp,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Verify OTP"),
            ),
            TextButton(
              onPressed: resendOtp,
              child: const Text("Resend OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
