import 'dart:typed_data';
import 'package:get/get.dart';
import '../models/silver_collection_model.dart';
import '../services/silver_collection_api_service.dart';

class SilverCollectionController extends GetxController {
  var isLoading = false.obs;
  var collections = <SilverCollection>[].obs;

  @override
  void onInit() {
    fetchCollections();
    super.onInit();
  }

  // Fetch all collections
  void fetchCollections() async {
    isLoading(true);
    try {
      collections.value = await SilverCollectionApiService.getCollections();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load silver collections. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Add collection without image
  Future<void> addCollection(SilverCollection collection) async {
    isLoading(true);
    try {
      final success = await SilverCollectionApiService.addCollection(collection);
      if (success) {
        fetchCollections();
        Get.snackbar(
          'Success',
          'Silver collection added successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add silver collection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Add collection with image
  Future<void> addCollectionWithImage({
    required String title,
    required String description,
    required String filePath,
    Uint8List? fileBytes,
  }) async {
    isLoading(true);
    try {
      final success = await SilverCollectionApiService.addCollectionWithImage(
        title: title,
        description: description,
        filePath: filePath,
        fileBytes: fileBytes,
      );
      if (success) {
        fetchCollections();
        Get.snackbar(
          'Success',
          'Silver collection with image added.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add silver collection with image.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Update collection without image
  Future<void> updateCollection(String id, SilverCollection collection) async {
    isLoading(true);
    try {
      final success = await SilverCollectionApiService.updateCollection(id, collection);
      if (success) {
        fetchCollections();
        Get.snackbar(
          'Success',
          'Silver collection updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update silver collection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Update with optional image
  Future<void> updateCollectionWithImage({
    required String id,
    required String title,
    required String description,
    String? filePath,
    Uint8List? fileBytes,
  }) async {
    isLoading(true);
    try {
      final success = await SilverCollectionApiService.updateCollectionWithImage(
        id: id,
        title: title,
        description: description,
        filePath: filePath,
        fileBytes: fileBytes,
      );
      if (success) {
        fetchCollections();
        Get.snackbar(
          'Success',
          'Silver collection updated with image.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update silver collection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Delete collection
  Future<void> deleteCollection(String id) async {
    isLoading(true);
    try {
      final success = await SilverCollectionApiService.deleteCollection(id);
      if (success) {
        fetchCollections();
        Get.snackbar(
          'Deleted',
          'Silver collection deleted.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete silver collection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
