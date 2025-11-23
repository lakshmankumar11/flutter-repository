import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/views/auth/login_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constantsApiBaseUrl.dart';

class SetPinPage extends StatefulWidget {
  const SetPinPage({Key? key}) : super(key: key);

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  String setPin = "";
  String confirmPin = "";
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> submitPin() async {
    if (setPin.length != 4 || confirmPin.length != 4) {
      showMessage("Please enter a valid 4-digit PIN.");
      return;
    }

    if (setPin != confirmPin) {
      showMessage("PINs do not match!");
      return;
    }

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
  

    if (token == null) {
      showMessage("Session expired. Please login again.");
      setState(() => isLoading = false);
      return;
    }

    final url = Uri.parse('${AppConstants.baseUrl}/auth/set-pin');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "pin": setPin,
          "confirmPin": confirmPin,
        }),
      );
      
if (response.statusCode == 200) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("PIN set successfully")),
     
    
  );

  await Future.delayed(const Duration(milliseconds: 300));

  if (!mounted) return;

  // Safe navigation after UI frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
   Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => LoginPage()),
);

  
  });
}


 else {
        final resData = jsonDecode(response.body);
        final msg = resData['message'] ?? 'Failed to set PIN';
        showMessage(msg);
      }
    } catch (e) {
      showMessage("Something went wrong. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(title: Text("Set Your PIN")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30),
              Text("Create a 4-digit PIN", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              PinCodeTextField(
                length: 4,
                obscureText: true,
                animationType: AnimationType.fade,
                appContext: context,
                keyboardType: TextInputType.number,
                onChanged: (value) => setPin = value,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeColor: Colors.amber,
                  selectedColor: Colors.amber.shade700,
                  inactiveColor: Colors.grey.shade300,
                ),
              ),
              SizedBox(height: 20),
              Text("Confirm your PIN", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              PinCodeTextField(
                length: 4,
                obscureText: true,
                animationType: AnimationType.fade,
                appContext: context,
                keyboardType: TextInputType.number,
                onChanged: (value) => confirmPin = value,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeColor: Colors.amber,
                  selectedColor: Colors.amber.shade700,
                  inactiveColor: Colors.grey.shade300,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.check_circle),
                label: isLoading
                    ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text("Confirm & Proceed"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading ? null : submitPin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
