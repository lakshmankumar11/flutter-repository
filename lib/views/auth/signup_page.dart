import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constantsApiBaseUrl.dart';
import 'OTPVerificationPage.dart';

class SignupPage extends StatefulWidget {
  final bool isForgotPin;

  const SignupPage({this.isForgotPin = false, super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() => _opacity = 1.0);
    });
  }

  Future<void> sendOtp() async {
    final url = Uri.parse('${AppConstants.baseUrl}/auth/send-otp');
    final formattedPhone = "+91${phoneController.text.trim()}";
    final name = nameController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', formattedPhone);
    await prefs.setInt('phoneExpiry', DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch);

    if (!widget.isForgotPin) {
      await prefs.setString('name', name);
      await prefs.setInt('nameExpiry', DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch);
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobile': formattedPhone,
          if (!widget.isForgotPin) 'username': name,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationPage(
              phone: formattedPhone,
              isForgotPin: widget.isForgotPin,
            ),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        showMessage(data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      showMessage("Something went wrong. Try again.");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: Text(widget.isForgotPin ? "Reset PIN" : "Sign Up"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: _opacity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                widget.isForgotPin ? Icons.lock_reset : Icons.person_add,
                size: 100,
                color: Colors.amber.shade700,
              ),
              SizedBox(height: 30),
              if (!widget.isForgotPin)
                _buildInputField(
                  controller: nameController,
                  label: "Your Name",
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name, // ✅ fixed
                ),
              if (!widget.isForgotPin) SizedBox(height: 16),
              _buildInputField(
                controller: phoneController,
                label: "Phone Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.send_to_mobile),
                label: Text(widget.isForgotPin ? "Send Reset OTP" : "Send OTP"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: sendOtp,
              ),
              if (!widget.isForgotPin)
                TextButton(
                  child: Text("Already have an account? Login"),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
