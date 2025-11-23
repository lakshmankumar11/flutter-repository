import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/payment_history_model.dart';
import '../../../views/config/constantsApiBaseUrl.dart';

class PaymentHistoryService {
  static Future<List<PaymentHistoryModel>> fetchAllPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      // throw Exception("No auth token found");
    }

    final url = '${AppConstants.baseUrl}/admin/allpayments';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['histories'] != null && data['histories'] is List) {
        return (data['histories'] as List)
            .map((e) => PaymentHistoryModel.fromJson(e))
            .toList();
      } else {
        throw Exception("No payment histories found in response");
      }
    } else {
      throw Exception("Failed to load payments (${response.statusCode})");
    }
  }
}
