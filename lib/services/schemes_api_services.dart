import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schemes_model.dart';
import '../views/config/constantsApiBaseUrl.dart';

class SchemeApiService {
  /// GET schemes
  static Future<List<SchemeModel>> fetchSchemesForUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}/scheme/$userId"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> schemesJson = data['schemes'];
      return schemesJson.map((json) => SchemeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch scheme: ${response.statusCode}');
    }
  }

  /// POST create
  static Future<bool> createScheme(SchemeModel scheme) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getString('user_id');

    if (token == null || userId == null) {
      throw Exception('User not authenticated');
    }

    final url = "${AppConstants.baseUrl}/scheme/$userId";
    final body = jsonEncode(scheme.toJson());

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    return response.statusCode == 201;
  }

  /// PUT update
  static Future<bool> updateScheme(SchemeModel scheme) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || scheme.id == null) {
      throw Exception('Missing auth or scheme ID');
    }

    final response = await http.put(
      Uri.parse("${AppConstants.baseUrl}/scheme/${scheme.id}"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(scheme.toJson()),
    );

    return response.statusCode == 200;
  }
}
