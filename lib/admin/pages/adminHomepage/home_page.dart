import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/admin/pages/adminHomepage/AdminStatsPage.dart';
import '../../../controller/UserController.dart';

class AdminHomeInnerPage extends StatelessWidget {
  const AdminHomeInnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    // Fetch user profile if not already fetched
    if (controller.user.value == null && !controller.isLoading.value) {
      controller.fetchUserProfile();
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = controller.user.value;
      if (user == null) {
        return const Center(child: Text('No user data'));
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Welcome to Admin Home',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, size: 32),
                title: Text(user['name'] ?? 'Name not found'),
              ),
            ),
            const SizedBox(height: 16),
            AdminStatsPage(), // Add stats outside the ListTile, not in subtitle
          ],
        ),
      );
    });
  }
}
