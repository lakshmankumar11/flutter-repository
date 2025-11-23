import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/admin/pages/collection_handlling/gold_silver_collection/gold_grid_img_upload.dart';
import 'package:gold_purchase_app/admin/pages/collection_handlling/gold_silver_collection/silver_grid_img_upload.dart';
import 'package:gold_purchase_app/admin/pages/collection_handlling/sliderControll/slider_img_upload.dart';

// Import controllers
import 'package:gold_purchase_app/controller/image_controller.dart'; // for Slider
import '../../adminApis/controllers/gold_collection_controller.dart';  // for Gold
import '../../adminApis/controllers/silver_collection_controller.dart'; // for Silver

class CollectionhandlingPage extends StatefulWidget {
  const CollectionhandlingPage({super.key});

  @override
  State<CollectionhandlingPage> createState() => _CollectionhandlingPageState();
}

class _CollectionhandlingPageState extends State<CollectionhandlingPage> {
  String selectedPage = 'default';

  // Controllers
  final ImageController sliderController = Get.put(ImageController()); // Slider
  final CollectionController goldController = Get.put(CollectionController()); // Gold
  final SilverCollectionController silverController = Get.put(SilverCollectionController()); // Silver

  Widget getCurrentPage() {
    switch (selectedPage) {
      case 'gold':
        return const AdminGoldGridPage();
      case 'silver':
        return const AdminSilverGridPage();
      default:
        return const SliderImgUploadHandling();
    }
  }

  String getPageTitle() {
    switch (selectedPage) {
      case 'gold':
        return 'Gold Grid Page';
      case 'silver':
        return 'Silver Grid Page';
      default:
        return 'Main Slider Upload';
    }
  }

  Future<void> refreshCurrentPage() async {
    switch (selectedPage) {
      case 'gold':
         goldController.fetchCollections();
        break;
      case 'silver':
         silverController.fetchCollections();
        break;
      default:
        await sliderController.fetchImages();
    }

    Get.snackbar(
      "Refreshed",
      "Images refreshed successfully!",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Widget buildDrawerItem({
    required String pageKey,
    required IconData icon,
    required String title,
  }) {
    final isSelected = selectedPage == pageKey;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.black : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.black : Colors.grey[800],
        ),
      ),
      tileColor: isSelected ? Colors.amber.shade100 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        setState(() => selectedPage = pageKey);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getPageTitle(),
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            tooltip: "Refresh Current Page",
            icon: const Icon(Icons.refresh),
            onPressed: refreshCurrentPage,
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.amber),
                child: Center(
                  child: Text(
                    'Slider Menu',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    buildDrawerItem(
                      pageKey: 'default',
                      icon: Icons.image,
                      title: 'Main Slider Upload',
                    ),
                    buildDrawerItem(
                      pageKey: 'gold',
                      icon: Icons.star,
                      title: 'Gold Grid Page',
                    ),
                    buildDrawerItem(
                      pageKey: 'silver',
                      icon: Icons.star_border,
                      title: 'Silver Grid Page',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Slider Image Handling',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: getCurrentPage(),
            ),
          ),
        ],
      ),
    );
  }
}
