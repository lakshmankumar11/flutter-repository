import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/components/collections/gold_collections/gold_grid_page.dart';
import 'gold_slider_page.dart';

class GoldCollectionsMainPage extends StatelessWidget {
  const GoldCollectionsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'welcome_gold_collection'.tr,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // GoldSliderPage(), // Horizontal slider (optional)
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
        GoldGridPage(),
      ],
    );
  }
}
