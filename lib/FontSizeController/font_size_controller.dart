import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart'; // for FontSizeController

class FontSettingsPage extends StatelessWidget {
  FontSettingsPage({super.key});

  final fontController = Get.find<FontSizeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('font_settings_title'.tr), // 🌍 Translatable title
        backgroundColor: Colors.amber,
      ),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'adjust_text_size'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),

                // 🔠 Preview box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.amber.shade50,
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "preview_title".tr,
                        style: TextStyle(
                          fontSize: fontController.fontSize.value,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "preview_description".tr,
                        style: TextStyle(
                          fontSize: fontController.fontSize.value,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "${'font_size_label'.tr}: ${fontController.fontSize.value.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Slider(
                  value: fontController.fontSize.value,
                  min: 10,
                  max: 30,
                  divisions: 10,
                  label: fontController.fontSize.value.toStringAsFixed(0),
                  activeColor: Colors.amber,
                  onChanged: (value) {
                    fontController.fontSize.value = value;
                  },
                  onChangeEnd: (_) => fontController.increaseFont(),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: fontController.decreaseFont,
                      icon: const Icon(Icons.text_decrease),
                      label: Text('smaller_button'.tr),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade600),
                    ),
                    ElevatedButton.icon(
                      onPressed: fontController.increaseFont,
                      icon: const Icon(Icons.text_increase),
                      label: Text('larger_button'.tr),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade600),
                    ),
                    
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: fontController.resetFont,
                    icon: const Icon(Icons.refresh),
                    label: Text('reset_button'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade400,
                    ),
                  ),
                ),
                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'font_updated_title'.tr,
                        'font_updated_message'.tr,
                        backgroundColor: Colors.amber.shade100,
                        colorText: Colors.black87,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: Text(
                      'save_apply_button'.tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
