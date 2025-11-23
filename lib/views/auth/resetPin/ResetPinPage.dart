import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constantsApiBaseUrl.dart';

class ResetPinPage extends StatefulWidget {
  const ResetPinPage({super.key});

  @override
  State<ResetPinPage> createState() => _ResetPinPageState();
}

class _ResetPinPageState extends State<ResetPinPage> {
  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();
  bool isLoading = false;

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> resetPin() async {
    final pin = pinController.text.trim();
    final confirmPin = confirmPinController.text.trim();

    if (pin.length != 4 || confirmPin.length != 4) {
      showMessage("PIN must be 4 digits.");
      return;
    }
    if (pin != confirmPin) {
      showMessage("PINs do not match.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token == null) {
        showMessage("No token found. Please verify again.");
        setState(() => isLoading = false);
        return;
      }

      final url = Uri.parse('${AppConstants.baseUrl}/auth/reset-pin');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'pin': pin,
          'confirmPin': confirmPin,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showMessage("PIN reset successfully.");
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      } else {
        final msg = body['message'] ?? 'Reset failed';
        showMessage(msg);
      }
    } catch (e) {
      showMessage("Something went wrong. Try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset PIN")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your new 4-digit PIN",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New PIN',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            TextField(
              controller: confirmPinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm PIN',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : resetPin,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Reset PIN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
