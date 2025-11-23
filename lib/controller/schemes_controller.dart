import 'package:get/get.dart';
import '../models/schemes_model.dart';
import '../services/schemes_api_services.dart';

class SchemeController extends GetxController {
  /// All schemes
  var schemes = <SchemeModel>[].obs;

  /// Loading state
  var isLoading = false.obs;

  /// Flag to avoid refetching if already fetched
  var isSchemeDataFetched = false.obs;

  /// Selected scheme
  var selectedScheme = Rxn<SchemeModel>(); // Optional: For details/view/edit

  /// GET: Fetch schemes for user
  Future<void> loadSchemesForUser({bool forceRefresh = false}) async {
    if (isSchemeDataFetched.value && !forceRefresh) return;

    isLoading.value = true;

    try {
      final data = await SchemeApiService.fetchSchemesForUser();

      if (data.isNotEmpty) {
        schemes.assignAll(data);
        isSchemeDataFetched.value = true;
      } else {
        schemes.clear(); // Clear old data
        Get.snackbar("Notice", "No schemes available for this user.");
      }
    } catch (e) {
      schemes.clear();
      Get.snackbar("Error", "Failed to fetch schemes\n$e");
    } finally {
      isLoading.value = false;
    }
  }

  /// POST: Create scheme
  Future<void> createScheme(SchemeModel newScheme) async {
    isLoading.value = true;

    try {
      final success = await SchemeApiService.createScheme(newScheme);
      if (success) {
        await loadSchemesForUser(forceRefresh: true);
        Get.back(); // Close the screen/dialog
        Get.snackbar("Success", "Scheme created successfully");
      } else {
        Get.snackbar("Failed", "Could not create scheme");
      }
    } catch (e) {
      Get.snackbar("Error", "Creation failed\n$e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Get Flexi Plan scheme safely
  SchemeModel? getFlexiPlanScheme() {
    return schemes.firstWhereOrNull((s) => s.schemeType == 'flexi_plan');
  }
}
