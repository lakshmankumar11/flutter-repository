import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gold_purchase_app/admin/admin_main_dashboard.dart';
import 'package:gold_purchase_app/controller/user_details_controller.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_page.dart';
import '../config/constantsApiBaseUrl.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final phoneController = TextEditingController();
  final pinController = TextEditingController();
  bool isLoading = false;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    phoneController.clear();
    pinController.clear();

    _checkLoginStatus();

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() => _opacity = 1.0);
    });
  }

  /// Auto-login if token is valid for 7 days
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final loginTimeStr = prefs.getString('login_time');

    if (token != null && loginTimeStr != null) {
      final loginTime = DateTime.tryParse(loginTimeStr);
      if (loginTime != null && DateTime.now().difference(loginTime).inDays < 7) {

        final userDetailsController = Get.find<UserDetailsController>();
        await userDetailsController.loadUserDetails(); // auto fetch user details
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        await prefs.remove('auth_token');
        await prefs.remove('login_time');
      }
    }
  }

Future<void> loginUser() async {
  final phone = phoneController.text.trim();
  final pin = pinController.text.trim();

  if (phone.isEmpty || pin.isEmpty) {
    showMessage("Please enter mobile number and PIN.");
    return;
  }

  final mobile = "+91$phone"; // ✅ Add country code prefix here

  setState(() => isLoading = true);

  final url = Uri.parse('${AppConstants.baseUrl}/auth/login'); // make sure this endpoint is correct

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile, 'pin': pin}),
    );

    final data = jsonDecode(response.body);


if (response.statusCode == 200) {
  // showMessage(data['message'] ?? 'Login successfully.');
final token = data['token'];
final userId = data['user']['id']; // 👈 Extract user ID
final username = data['user']['username'] ?? ''; // 👈 Extract username safely
final role = data['user']['role'] ?? 'user'; // 👈 Extract role



  // ✅ Save token and user ID in SharedPreferences
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', token);
await prefs.setString('user_id', userId); // 👈 Save user ID
await prefs.setString('login_time', DateTime.now().toIso8601String());
await prefs.setString('username', username);
await prefs.setString('role', role); // 👈 Save role

  // ✅ Show Lottie dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: Container(
          color: Colors.black.withOpacity(0.8),
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

  // ✅ Wait for 3 seconds before closing the dialog and navigating
// ✅ Wait for 3 seconds before closing the dialog and navigatin

// ✅ Set isLoading = false before navigating
setState(() => isLoading = true);

final userDetailsController = Get.find<UserDetailsController>();
await userDetailsController.loadUserDetails();

await Future.delayed(const Duration(seconds: 2));
Navigator.pop(context); // Close the dialog

// ✅ Now navigate after setting isLoading = false
if (role.toLowerCase() == 'admin') {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const AdminMainDashboard()),
  );
} else {
  Navigator.pushReplacementNamed(context, '/home');
}




} else {
  showMessage(data['message'] ?? 'Login failed.');
}

  } catch (e) {
    showMessage('Error: ${e.toString()}');
  } finally {
    setState(() => isLoading = false);
  }
}

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(title: Text("Login")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: _opacity,
          curve: Curves.easeInOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 150,
                  child: Lottie.asset(
                    'assets/animations/goldanimation.json',
                    repeat: true,
                    animate: true,
                  ),
                ),
              ),
              SizedBox(height: 30),

              _buildInputField(
                controller: phoneController,
                label: "Mobile Number",
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              _buildInputField(
                controller: pinController,
                label: "PIN",
                icon: Icons.lock_outline,
                obscure: true,
                keyboardType: TextInputType.number,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupPage(isForgotPin: true)),
                    );
                  },
                  child: Text("Forgot PIN?"),
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: isLoading
                    ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text("Login"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading ? null : loginUser,
              ),

              TextButton(
                child: Text("Don't have an account? Sign up"),
                onPressed: () => Navigator.pushNamed(context, '/signup'),
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
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.amber),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
