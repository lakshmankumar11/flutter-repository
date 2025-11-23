import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_details_model.dart';
import '../views/config/constantsApiBaseUrl.dart';

class UserApiService {
  static Future<UserDetailsModel?> fetchUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final userId = prefs.getString('user_id') ?? '';

      if (token.isEmpty || userId.isEmpty) {
        return null;
      }

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/user/details/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final data = body['data'] ?? body; // adjust if no 'data' key
        return UserDetailsModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {

      return null;
    }
  }
}
