import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  // 📞 Call
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      Get.snackbar('Error', 'Could not launch phone app');
    }
  }

  // 💬 WhatsApp
  void _openWhatsApp(String number, String message) async {
    final Uri launchUri = Uri.parse("https://wa.me/$number?text=${Uri.encodeComponent(message)}");
    if (!await launchUrl(launchUri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not open WhatsApp');
    }
  }

  // 📸 Instagram
  void _openInstagram(String username) async {
    final Uri launchUri = Uri.parse("https://instagram.com/$username");
    if (!await launchUrl(launchUri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not open Instagram');
    }
  }

  // 🗺 Google Maps
  void _openGoogleMaps(String location) async {
    final Uri launchUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}");
    if (!await launchUrl(launchUri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not open Google Maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    const phoneNumber = "9487221747";
    const whatsappNumber = "9791392044";
    const whatsappMessage = "Hello, I want to inquire about your services.";
    const instagramUsername = "subagoldofficial";
    const location = "158-1, Near Subramania Kovil, Pollachi";

    return Scaffold(
      appBar: AppBar(
        title: Text('contact_us'.tr),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.call, color: Colors.green),
              title: Text('call_us'.tr),
              subtitle: Text(phoneNumber),
              onTap: () => _makePhoneCall(phoneNumber),
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.green),
              title: Text('whatsapp'.tr),
              subtitle: Text(whatsappNumber),
              onTap: () => _openWhatsApp(whatsappNumber, whatsappMessage),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.purple),
              title: Text('instagram'.tr),
              subtitle: Text('@$instagramUsername'),
              onTap: () => _openInstagram(instagramUsername),
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.red),
              title: Text('find_us'.tr),
              subtitle: Text(location),
              onTap: () => _openGoogleMaps(location),
            ),
          ],
        ),
      ),
    );
  }
}
