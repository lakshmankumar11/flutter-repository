import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import '../models/image_model.dart';
import '../services/images_api_service.dart';

class ImageController extends GetxController {
  RxList<ImageItem> images = <ImageItem>[].obs;
  RxBool isLoading = false.obs;
  RxBool isUploading = false.obs;
  RxBool isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  /// ✅ Fetch all images
  Future<void> fetchImages() async {
    isLoading.value = true;
    try {
      final result = await ApiService.fetchImages();
      images.value = result;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch images: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Upload image (web or mobile)
  Future<bool> uploadImage({
    File? file,
    Uint8List? bytes,
    String? fileName,
  }) async {
    isUploading.value = true;
    try {
      final success = await ApiService.uploadImage(
        file: file,
        bytes: bytes,
        fileName: fileName,
      );
      if (success) {
        Get.snackbar("Success", "Image uploaded");
        await fetchImages();
        return true;
      } else {
        Get.snackbar("Error", "Upload failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Upload failed: $e");
      return false;
    } finally {
      isUploading.value = false;
    }
  }

  /// ✅ Update single image by _id
  Future<bool> updateImage({
    required String imageId,
    File? file,
    Uint8List? bytes,
    String? fileName,
  }) async {
    isUpdating.value = true;
    try {
      final success = await ApiService.updateSingleImage(
        imageId: imageId,
        file: file,
        bytes: bytes,
        fileName: fileName,
      );
      if (success) {
        Get.snackbar("Success", "Image updated");
        await fetchImages();
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Update failed: $e");
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// ✅ Delete single image by _id
  Future<bool> deleteImage(String imageId) async {
    try {
      final success = await ApiService.deleteSingleImage(imageId);
      if (success) {
        images.removeWhere((img) => img.id == imageId);
        Get.snackbar("Success", "Image deleted");
        await fetchImages();
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Delete failed: $e");
      return false;
    }
  }
}
