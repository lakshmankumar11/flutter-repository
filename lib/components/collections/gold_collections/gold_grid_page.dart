import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../admin/adminApis/controllers/gold_collection_controller.dart';
import '../../../admin/adminApis/models/gold_collection_model.dart';

class GoldGridPage extends StatelessWidget {
  GoldGridPage({super.key});

  final CollectionController controller = Get.put(CollectionController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final List<Collection> collections = controller.collections;

      if (collections.isEmpty) {
        return const Center(child: Text("No gold items found"));
      }

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: collections.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final Collection item = collections[index];

            return InkWell(
              onTap: () {
                // Optional: Navigate to details page
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// Image section with icon
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            item.imageUrl,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 140,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, size: 50),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            // child: IconButton(
                            //   icon: const Icon(Icons.favorite_border, color: Colors.red),
                            //   onPressed: () {
                            //     // Future enhancement: add favorite logic
                            //   },
                            // ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF1E1E1E),
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
