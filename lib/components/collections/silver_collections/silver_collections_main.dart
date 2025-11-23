import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/components/collections/silver_collections/silver_grid_page.dart';
import 'silver_slider_page.dart';

class SilverCollectionsMainPage extends StatelessWidget {
  const SilverCollectionsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'welcome_silver_collection'.tr,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // SilverSliderPage(), // Horizontal slider (optional)
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'explore_more_categories'.tr,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 20),
        SilverGridPage(),
      ],
    );
  }
}
