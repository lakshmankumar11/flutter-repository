import 'package:get/get.dart';
import '../models/user_details_model.dart';
import '../services/user_api_service.dart';

class UserDetailsController extends GetxController {
  var isLoading = false.obs;
  var userDetails = Rxn<UserDetailsModel>();
  var error = ''.obs;

  Future<void> loadUserDetails() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await UserApiService.fetchUserDetails();

      if (result != null) {
        userDetails.value = result;
      } else {
        error.value = 'Failed to fetch user details';
      }
    } catch (e) {
      error.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    loadUserDetails();
    super.onInit();
  }
}
