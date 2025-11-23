import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user_scheme_model.dart';
import '../../../views/config/constantsApiBaseUrl.dart';
class UserSchemeService {
  static Future<List<UserSchemeModel>> fetchAllSchemes() async {
    final url = Uri.parse("${AppConstants.baseUrl}/admin/allschemes");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['schemeHistories'] is List) {
        final histories = jsonData['schemeHistories'] as List;
        final List<UserSchemeModel> allSchemes = [];

        for (var userJson in histories) {
          final userWithSchemes = UserWithSchemes.fromJson(userJson);
          allSchemes.addAll(userWithSchemes.schemes);
        }

        return allSchemes;
      } else {
        throw Exception("No schemeHistories found");
      }
    } else {
      throw Exception("Failed to fetch schemes: ${response.statusCode}");
    }
  }
}
