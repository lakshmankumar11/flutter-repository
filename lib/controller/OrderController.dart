import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/transaction_model.dart';
import '../views/config/constantsApiBaseUrl.dart';

class OrderController extends GetxController {
  final transactions = <TransactionModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  Future<void> fetchOrders() async {
    isLoading.value = true;
    error.value = '';
    transactions.clear(); // Clear old data before fetching new

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final userId = prefs.getString('user_id') ?? '';

      if (token.isEmpty || userId.isEmpty) {
        error.value = 'Missing token or user ID';
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/order/history/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<dynamic> historyList = data['history'] ?? [];

        transactions.value = historyList
            .map((item) => TransactionModel.fromJson(item))
            .toList();
      } else {
        error.value = 'Failed to fetch orders: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
