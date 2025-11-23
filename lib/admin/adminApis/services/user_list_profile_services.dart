import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_list_profile_model.dart';
import '../../../views/config/constantsApiBaseUrl.dart';

class UserService {
  static Future<List<UserModel>> fetchAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final url = Uri.parse('${AppConstants.baseUrl}/user/all');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> usersJson = data['users']; // adjust if response changes
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }
}
