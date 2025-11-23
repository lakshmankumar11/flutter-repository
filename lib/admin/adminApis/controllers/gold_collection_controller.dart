import 'dart:typed_data';
import 'package:get/get.dart';
import '../models/gold_collection_model.dart';
import '../services/gold_collection_api_service.dart';

class CollectionController extends GetxController {
  var isLoading = false.obs;
  var collections = <Collection>[].obs;

  @override
  void onInit() {
    fetchCollections();
    super.onInit();
  }

  // Fetch all collections
  void fetchCollections() async {
    isLoading(true);
    try {
      collections.value = await CollectionApiService.getCollections();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load collections. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Add collection without image (not used directly in UI now)
  Future<void> addCollection(Collection collection) async {
    isLoading(true);
    try {
      final success = await CollectionApiService.addCollection(collection);
      if (success) {
        fetchCollections();
        Get.snackbar(
          'Success',
          'Collection added successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add collection. Please check your input or try again.',
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
      final success = await CollectionApiService.addCollectionWithImage(
        title: title,
        description: description,
        filePath: filePath,
        fileBytes: fileBytes,
      );
      if (success) {
        fetchCollections();
        Get.snackbar(
          'Success',
          'Collection with image added successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add collection with image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Update collection with basic info (not used directly now)
  Future<void> updateCollection(String id, Collection collection) async {
    isLoading(true);
    try {
      final success = await CollectionApiService.updateCollection(id, collection);
      if (success) {
        fetchCollections();
        Get.snackbar(
          'Success',
          'Collection updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update collection. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // ✅ Update collection with optional image
  Future<void> updateCollectionWithImage({
    required String id,
    required String title,
    required String description,
    String? filePath,
    Uint8List? fileBytes,
  }) async {
    isLoading(true);
    try {
      final success = await CollectionApiService.updateCollectionWithImage(
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
          'Collection updated with image successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update collection. Please check the image and try again.',
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
      final success = await CollectionApiService.deleteCollection(id);
      if (success) {
        fetchCollections();
        Get.snackbar(
          'Deleted',
          'Collection deleted successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete collection. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
