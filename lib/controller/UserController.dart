import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:image_picker/image_picker.dart';
import '../views/config/constantsApiBaseUrl.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<Map<String, dynamic>>();
  String? token;
  String? userId;

  @override
  void onInit() {
    super.onInit();
    // fetchUserProfile();
  }

  void clearUserData() {
    user.value = null;
    token = null;
    userId = null;
  }

  /// Helper: Extract userId from token
  String? extractUserId(String? token) {
    if (token == null) return null;
    final decoded = JwtDecoder.decode(token);
    return decoded['userId'] ?? decoded['_id'] ?? decoded['id'];
  }

  /// Load token & userId from SharedPreferences
  Future<void> loadTokenAndUserId() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    if (token != null) {
      userId = extractUserId(token);
    }
  }

  /// Fetch user profile (requires login)
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      clearUserData();

      await loadTokenAndUserId();
      if (token == null || userId == null) {
        Get.snackbar("Error", "Please login to continue.");
        return;
      }

      final uri = Uri.parse('${AppConstants.baseUrl}/user/profile/$userId');
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        user.value = jsonResponse['user'];
      } else {
        final jsonError = jsonDecode(response.body);
        final message = jsonError['message'] ?? 'Failed to fetch user profile';
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile with optional image
  Future<void> updateUserProfile({
    required String name,
    required String address,
    required String ifsc,
    required String accountNo,
    required String aadharNumber,
    String? mobile,
    String? username,
    String? referralCode,
    XFile? aadharImage,
  }) async {
    try {
      isLoading.value = true;

      await loadTokenAndUserId();
      if (token == null || userId == null) {
        Get.snackbar("Error", "Please login to update profile.");
        return;
      }

      final uri = Uri.parse('${AppConstants.baseUrl}/user/profile/$userId');
      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = name;
      request.fields['address'] = address;
      request.fields['ifsc'] = ifsc;
      request.fields['accountNo'] = accountNo;
      request.fields['aadharNumber'] = aadharNumber;

      if (mobile != null) request.fields['mobile'] = mobile;
      if (username != null) request.fields['username'] = username;
      if (referralCode != null && referralCode.isNotEmpty) {
        request.fields['referralCode'] = referralCode;
      }

      if (aadharImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'aadharImage',
          aadharImage.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        user.value = jsonResponse['user'];
        Get.snackbar("Success", jsonResponse['message'] ?? "Profile updated successfully");
      } else {
        final jsonError = jsonDecode(response.body);
        final message = jsonError['message'] ?? 'Failed to update profile';
        Get.snackbar("Error", message);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", "").trim());
    } finally {
      isLoading.value = false;
    }
  }
}
