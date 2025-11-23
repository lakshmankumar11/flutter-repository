import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../views/config/constantsApiBaseUrl.dart';

class NewAdminCreatePage extends StatefulWidget {
  const NewAdminCreatePage({super.key});

  @override
  State<NewAdminCreatePage> createState() => _NewAdminCreatePageState();
}

class _NewAdminCreatePageState extends State<NewAdminCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  final String apiUrl = '${AppConstants.baseUrl}/admin/create';

  Future<void> createAdmin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'mobile': '+91${mobileController.text.trim()}',
          'pin': passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Admin Created: ${data['admin']['name']}')),
        );
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Error: ${data['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('⚠️ Server error')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Admin'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: inputStyle('Name'),
                validator: (val) => val!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: inputStyle('Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter email';
                  if (!val.contains('@')) return 'Enter valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: mobileController,
                decoration: inputStyle('Mobile (10 digits)'),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter mobile number';
                  if (val.length != 10) return 'Must be 10 digits';
                  final last4 = val.substring(val.length - 4);
                  if (!RegExp(r'^\d{4}$').hasMatch(last4)) {
                    return 'Last 4 digits must be numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: inputStyle('4-digit Password'),
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter password';
                  if (val.length != 4) return 'Must be 4 digits';
                  if (!RegExp(r'^\d{4}$').hasMatch(val))
                    return 'Only 4 numbers allowed';
                  return null;
                },
              ),

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : createAdmin,
                  icon: const Icon(Icons.person_add_alt_1),
                  label: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Create Admin',
                          style: TextStyle(fontSize: 16),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 211, 219, 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
