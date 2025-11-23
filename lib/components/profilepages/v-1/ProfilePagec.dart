import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_profile_pagec.dart';
import '../../../controller/UserController.dart';
import 'package:flutter/services.dart';

class ProfilePagec extends StatefulWidget {
  const ProfilePagec({super.key});

  @override
  State<ProfilePagec> createState() => _ProfilePagecState();
}

class _ProfilePagecState extends State<ProfilePagec> {
  final Color goldColor = const Color(0xFFFFD700);
  final UserController controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (controller.user.value == null && !controller.isLoading.value) {
        controller.fetchUserProfile();
      }
    });
  }

  bool isProfileIncomplete(Map<String, dynamic> user) {
    return user['name'] == null ||
        user['name'].toString().isEmpty ||
        user['mobile'] == null ||
        user['mobile'].toString().isEmpty ||
        user['address'] == null ||
        user['address'].toString().isEmpty ||
        user['aadharNumber'] == null ||
        user['aadharNumber'].toString().isEmpty ||
        user['accountNo'] == null ||
        user['ifsc'] == null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = controller.user.value;
      if (user == null) {
        return Center(child: Text('no_user_data'.tr));
      }

      final bool isIncomplete = isProfileIncomplete(user);

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Credits
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: goldColor.withOpacity(0.1),
                      border: Border.all(color: goldColor, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.amber, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          '${'credits'.tr}: ${user['wallet']?.toString() ?? '0'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFFFFD700),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user['name'] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['mobile'] ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  _buildItem(Icons.location_on, 'address'.tr, user['address']),
                  _buildItem(Icons.credit_card, 'aadhar_number'.tr, user['aadharNumber']),
                  _buildItem(Icons.account_balance, 'account_no'.tr, user['accountNo']),
                  _buildItem(Icons.code, 'ifsc'.tr, user['ifsc']),
                  _buildCopyableItem(Icons.card_giftcard, 'referral_code'.tr, user['referralCode']),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (user['aadharImageUrl'] != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'aadhar_image'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  user['aadharImageUrl'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],

            ElevatedButton.icon(
              onPressed: () => Get.to(() => const EditProfilePage()),
              icon: Icon(
                isIncomplete ? Icons.person_add : Icons.edit,
                color: Colors.black,
              ),
              label: Text(
                isIncomplete ? 'create_profile'.tr : 'edit_profile'.tr,
                style: const TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildItem(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.amber[700]),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                children: [
                  TextSpan(
                    text: value ?? 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableItem(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.amber[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "$label: ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: value ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (value != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.copy, size: 18, color: Colors.black54),
                    tooltip: 'copy'.tr,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));
                      Get.snackbar(
                        'copied'.tr,
                        'referral_copied'.tr,
                        backgroundColor: Colors.green.shade100,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
