import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../views/config/constantsApiBaseUrl.dart';

class GoldRateProvider with ChangeNotifier {
  double? _gold999Rate;
  double? _silver999Rate;
  bool _isLoading = false;
  String? _error;
  bool _hasFetched = false;

  double? get gold999Rate => _gold999Rate;
  double? get silver999Rate => _silver999Rate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMetalPrices({bool silent = false}) async {
    if (_hasFetched) return;

    if (!silent) {
      _isLoading = true;
      notifyListeners();
    }

    _error = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null) {
        _error = 'Token not found.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/price/metal-prices'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> prices = data['metalPrices'];

        final gold = prices.firstWhere(
          (item) => item['metal'] == 'gold' && item['purity'] == 'gold-999',
          orElse: () => null,
        );

        final silver = prices.firstWhere(
          (item) => item['metal'] == 'silver' && item['purity'] == 'silver-999',
          orElse: () => null,
        );

        _gold999Rate = gold != null ? (gold['price']['1g'] as num).toDouble() : null;
        _silver999Rate = silver != null ? (silver['price']['1g'] as num).toDouble() : null;

        if (_gold999Rate == null && _silver999Rate == null) {
          _error = 'No matching metal prices found';
        } else {
          _hasFetched = true;
        }
      } else {
        _error = 'Failed to load metal prices: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    if (!silent) {
      _isLoading = false;
    }

    notifyListeners();
  }

  void clearFetchedStatus() {
    _hasFetched = false;
  }
}
