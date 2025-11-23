import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../../../../controller/UserController.dart'; // Adjust path as needed
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../views/config/constantsApiBaseUrl.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({Key? key}) : super(key: key);

  void _copyToClipboard(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('referral_copied'.tr)),
    );
  }

  void _shareCode(String code) {
    Share.share("${'share_referral'.tr} $code ${'invite_rewards'.tr}");
  }

  void _showReferralInputModal(BuildContext context, UserController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController _referralInputController = TextEditingController();

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'enter_referral'.tr,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _referralInputController,
                  decoration: InputDecoration(
                    hintText: 'referral_hint'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String enteredCode = _referralInputController.text.trim();
                    if (enteredCode.isNotEmpty) {
                      Navigator.pop(context);

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? token = prefs.getString('auth_token');
                      String? userId = prefs.getString('user_id');

                      if (token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('token_not_found'.tr)),
                        );
                        return;
                      }

                      try {
                        final url = Uri.parse("${AppConstants.baseUrl}/referral/apply/$userId");

                        final response = await http.post(
                          url,
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $token',
                          },
                          body: jsonEncode({"referralCode": enteredCode}),
                        );

                        if (response.statusCode == 200) {
                          final data = jsonDecode(response.body);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(data['message'] ?? 'referral_applied'.tr),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          await controller.fetchUserProfile();
                        } else {
                          final error = jsonDecode(response.body);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error['message'] ?? 'referral_failed'.tr),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${'error_occurred'.tr}: $e"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('submit'.tr),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Method to return translated Terms & Conditions as a string
  String getTermsAndConditions() {
    
    return """
• ${'gold_purchase_only'.tr}
• ${'scheme_duration'.tr}
• ${'fixed_monthly_amount'.tr}
• ${'bonus_if_all_paid'.tr}
• ${'missed_month'.tr}
• ${'no_bonus_conditions'.tr}
• ${'redemption_after_11_months'.tr}
• ${'redemption_gold_only'.tr}
• ${'gold_rate_on_redemption'.tr}
• ${'making_charges_extra'.tr}
• ${'bonus_special_case'.tr}
• ${'min_1gram_only'.tr}
• ${'balance_if_less'.tr}
• ${'premature_closure'.tr}
• ${'no_cash_refund'.tr}
• ${'non_transferable'.tr}
• ${'valid_id_required'.tr}
• ${'save_receipts'.tr}
• ${'disputes_pollachi'.tr}
• ${'management_final_decision'.tr}
""";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    if (controller.user.value == null && !controller.isLoading.value) {
      controller.fetchUserProfile();
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final user = controller.user.value;
      if (user == null) {
        return Scaffold(body: Center(child: Text('no_user_data'.tr)));
      }

      final String code = user['referralCode'] ?? "SUBAGOLD123";

      return Scaffold(
        appBar: AppBar(
          title: Text('refer_earn'.tr, style: const TextStyle(color: Colors.black)),
          backgroundColor: const Color.fromARGB(255, 231, 178, 4),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: FadeInDown(
                  child: Column(
                    children: [
                      const Icon(Icons.card_giftcard, size: 70, color: Colors.amber),
                      const SizedBox(height: 10),
                      Text(
                        'invite_rewards'.tr,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'invite_description'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              /// Referral Code Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        code,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis, // Prevent overflow
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.black87),
                      onPressed: () => _copyToClipboard(context, code),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// Share Button
              ElevatedButton.icon(
                onPressed: () => _shareCode(code),
                icon: const Icon(Icons.share),
                label: Text('share_code'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 40),

              /// Terms & Conditions / Description
                  Container(
                      width: double.infinity,
                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.shade200, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.rule, color: Colors.amber, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              'terms_conditions'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          getTermsAndConditions(),
                          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
                        ),
                      ],
                    ),
                  ),

              const SizedBox(height: 20),

              /// Have a referral code?
              InkWell(
                onTap: () => _showReferralInputModal(context, controller),
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.amber.shade100,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.amber, width: 1.2),
                  ),
                  child: Text(
                    'have_referral'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}
