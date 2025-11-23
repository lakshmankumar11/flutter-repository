import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../controller/UserController.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<UserController>();
  final Color goldColor = const Color(0xFFFFD700);

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController ifscController;
  late TextEditingController accountNoController;
  late TextEditingController aadharController;

  XFile? pickedAadharImage;
  bool isProfileCreated = false;

  @override
  void initState() {
    super.initState();
    final user = controller.user.value ?? {};

    nameController = TextEditingController(text: user['name'] ?? '');
    addressController = TextEditingController(text: user['address'] ?? '');
    ifscController = TextEditingController(text: user['ifsc'] ?? '');
    accountNoController = TextEditingController(text: user['accountNo'] ?? '');
    aadharController = TextEditingController(text: user['aadharNumber'] ?? '');

    isProfileCreated = _checkIfProfileExists(user);
  }

  bool _checkIfProfileExists(Map<String, dynamic> user) {
    return (user['name']?.isNotEmpty ?? false) &&
        (user['address']?.isNotEmpty ?? false) &&
        (user['ifsc']?.isNotEmpty ?? false) &&
        (user['accountNo']?.isNotEmpty ?? false) &&
        (user['aadharNumber']?.isNotEmpty ?? false) &&
        (user['aadharImageUrl']?.isNotEmpty ?? false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedAadharImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = controller.user.value ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isProfileCreated ? 'edit_profile'.tr : 'create_profile'.tr,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: goldColor,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInput(nameController, 'name'.tr),
              _buildInput(addressController, 'address'.tr),
              _buildIFSCInput(ifscController),
              _buildInput(accountNoController, 'account_no'.tr, validator: _validateAccountNo),
              _buildInput(aadharController, 'aadhar_number'.tr, validator: _validateAadhar),

              const SizedBox(height: 16),

              if (user['aadharImageUrl'] != null && pickedAadharImage == null)
                _buildImageSection('current_aadhar'.tr, Image.network(user['aadharImageUrl'], height: 150, fit: BoxFit.cover)),

              if (pickedAadharImage != null)
                _buildImageSection('selected_new_image'.tr, Image.file(File(pickedAadharImage!.path), height: 150, fit: BoxFit.cover)),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("pick_aadhar_image".tr),
              ),

              const SizedBox(height: 20),
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await controller.updateUserProfile(
                            name: nameController.text.trim(),
                            address: addressController.text.trim(),
                            ifsc: ifscController.text.trim(),
                            accountNo: accountNoController.text.trim(),
                            aadharNumber: aadharController.text.trim(),
                            aadharImage: pickedAadharImage,
                          );

                          setState(() {
                            isProfileCreated = true;
                          });

                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        "save_changes".tr,
                        style: const TextStyle(fontSize: 16),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: goldColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label ${'required'.tr}';
              }
              return null;
            },
      ),
    );
  }

  Widget _buildIFSCInput(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          final upper = value.toUpperCase();
          controller.value = TextEditingValue(
            text: upper,
            selection: TextSelection.collapsed(offset: upper.length),
          );
        },
        decoration: InputDecoration(
          labelText: 'ifsc'.tr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: goldColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: _validateIFSC,
      ),
    );
  }

  String? _validateIFSC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ifsc_required'.tr;
    }
    final pattern = RegExp(r'^[A-Z]{4}[0-9]{7}$');
    if (!pattern.hasMatch(value.trim().toUpperCase())) {
      return 'ifsc_invalid'.tr;
    }
    return null;
  }

  String? _validateAadhar(String? value) {
    if (value == null || value.trim().isEmpty) return 'aadhar_required'.tr;
    if (!RegExp(r'^\d{12}$').hasMatch(value)) return 'aadhar_invalid'.tr;
    return null;
  }

  String? _validateAccountNo(String? value) {
    if (value == null || value.trim().isEmpty) return 'account_required'.tr;
    if (!RegExp(r'^\d{9,18}$').hasMatch(value)) return 'account_invalid'.tr;
    return null;
  }

  Widget _buildImageSection(String title, Widget imageWidget) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: goldColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          imageWidget,
        ],
      ),
    );
  }
}
