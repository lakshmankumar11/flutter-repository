import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/FontSizeController/font_size_controller.dart';
import 'package:gold_purchase_app/components/profilepages/contact_us_page/contact_us_page.dart';
import 'package:gold_purchase_app/components/profilepages/v-1/ReferralPage/ReferralPage.dart';
import 'ProfilePagec.dart';
import '../kyc_verification/kyc_verification_page.dart';
import '../../../utils/logout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;

    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'my_profile'.tr,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),

      endDrawer: Drawer(
        backgroundColor: Colors.amber.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.amber),
              child: Center(
                child: Text(
                  'my_account'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.verified_user,
                color: Color.fromARGB(255, 23, 226, 5),
              ),
              title: Text("kyc_update".tr),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const KYCVerificationPage());
              },
            ),

            // ✅ Logout with confirmation dialog
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.amber),
              title: Text("logout".tr),
              onTap: () {
                Navigator.pop(context); // close drawer
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("logout".tr),
                    content: Text("are_you_sure_logout".tr), // localize
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                        },
                        child: Text("cancel".tr),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogoutPage(),
                            ),
                          );
                        },
                        child: Text("yes".tr),
                      ),
                    ],
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.card_giftcard, color: Colors.purple),
              title: Text("referral_code".tr),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReferralPage()),
                );
              },
            ),

            // 🌐 Language Option
            ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: Text("language".tr),
              trailing: DropdownButton<Locale>(
                underline: const SizedBox(),
                value: Get.locale,
                items: const [
                  DropdownMenuItem(
                    value: Locale('en', 'US'),
                    child: Text("English"),
                  ),
                  DropdownMenuItem(
                    value: Locale('ta', 'IN'),
                    child: Text("தமிழ்"),
                  ),
                ],
                onChanged: (locale) {
                  if (locale != null) {
                    Get.updateLocale(locale);
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.text_fields, color: Colors.amber),
              title: Text('font_settings_title'.tr),
              onTap: () {
                Get.to(() => FontSettingsPage());
              },
            ),
             ListTile(
              leading: const Icon(Icons.contact_page, color: Colors.amber),
              title: Text('contact_us'.tr),
              onTap: () {
                Get.to(() => ContactUsPage());
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [ProfilePagec(), SizedBox(height: 20)],
        ),
      ),
    );
  }
}
