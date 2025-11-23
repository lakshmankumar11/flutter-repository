import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import '../../controller/image_controller.dart'; // adjust path if needed

class SwiperBanner extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.images.isEmpty) {
        return const SizedBox(
          height: 180,
          child: Center(child: Text("No banners available")),
        );
      }

      return SizedBox(
        height: 180,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                controller.images[index].imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
          autoplay: true,
          itemCount: controller.images.length,
          pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              activeColor: Colors.amber.shade800,
              color: Colors.amber.shade200,
              size: 8.0,
              activeSize: 10.0,
            ),
          ),
          control: SwiperControl(color: Colors.amber.shade800),
          viewportFraction: 0.9,
          scale: 0.95,
        ),
      );
    });
  }
}
