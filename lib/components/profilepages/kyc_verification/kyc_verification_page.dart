import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KYCVerificationPage extends StatefulWidget {
  const KYCVerificationPage({Key? key}) : super(key: key);

  @override
  State<KYCVerificationPage> createState() => _KYCVerificationPageState();
}

class _KYCVerificationPageState extends State<KYCVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String pan = '';
  String aadhaar = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('kyc_verification'.tr),
        backgroundColor: Colors.amber[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'fill_details'.tr,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Full Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'full_name'.tr,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'enter_name'.tr : null,
                onSaved: (value) => name = value!,
              ),
              const SizedBox(height: 20),

              // PAN Card Number
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'pan_number'.tr,
                  border: const OutlineInputBorder(),
                ),
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'enter_pan'.tr;
                  if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
                    return 'valid_pan'.tr;
                  }
                  return null;
                },
                onSaved: (value) => pan = value!,
              ),
              const SizedBox(height: 20),

              // Aadhaar Number
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'aadhaar_number'.tr,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 12,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'enter_aadhaar'.tr;
                  if (value.length != 12) return 'aadhaar_length'.tr;
                  return null;
                },
                onSaved: (value) => aadhaar = value!,
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('submitted'.tr),
                        content: Text(
                          'Name: $name\nPAN: $pan\nAadhaar: $aadhaar\n\n${'kyc_success'.tr}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('ok'.tr),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text(
                  'submit_kyc'.tr,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
