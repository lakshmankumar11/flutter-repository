import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gold_sales_model.dart';
import '../../../views/config/constantsApiBaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  static Future<GoldSalesModel?> fetchGoldSales() async {
    const String url = '${AppConstants.baseUrl}/admin/list'; // ✅ Your API endpoint

    try {
      // ✅ Get the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // ✅ Return null if no token is found
      if (token == null || token.isEmpty) {
        print("❌ Token not found");
        return null;
      }

      // ✅ Make GET request with Authorization header
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['status'] == 'success') {
          return GoldSalesModel.fromJson(jsonBody['data']);
        }
      } else {
        print("❌ API Error: ${response.statusCode} - ${response.body}");
      }

      return null;
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}

