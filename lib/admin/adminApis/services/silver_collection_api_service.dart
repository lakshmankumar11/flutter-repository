import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/silver_collection_model.dart'; // Create this model similar to gold one
import '../../../views/config/constantsApiBaseUrl.dart';

class SilverCollectionApiService {
  // 🔐 Get token from local storage
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // 📥 GET all silver collections
  static Future<List<SilverCollection>> getCollections() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/silvercollection'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => SilverCollection.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load silver collections');
    }
  }

  // 🆕 POST: Add collection (no image)
  static Future<bool> addCollection(SilverCollection collection) async {
    final token = await _getToken();
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/silvercollection'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(collection.toJson()),
    );
    return res.statusCode == 201;
  }

  // 🆕 POST: Add with image
  static Future<bool> addCollectionWithImage({
    required String title,
    required String description,
    required String filePath,
    Uint8List? fileBytes,
  }) async {
    final token = await _getToken();
    var uri = Uri.parse('${AppConstants.baseUrl}/silvercollection');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;

    if (kIsWeb) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        fileBytes!,
        filename: 'upload.jpg',
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath('image', filePath));
    }

    var response = await request.send();
    return response.statusCode == 201;
  }

  // 🔄 PUT: Update without image
  static Future<bool> updateCollection(String id, SilverCollection collection) async {
    final token = await _getToken();
    final res = await http.put(
      Uri.parse('${AppConstants.baseUrl}/silvercollection/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(collection.toJson()),
    );
    return res.statusCode == 200;
  }

  // 🔄 PUT: Update with image
  static Future<bool> updateCollectionWithImage({
    required String id,
    required String title,
    required String description,
    String? filePath,
    Uint8List? fileBytes,
  }) async {
    final token = await _getToken();
    final uri = Uri.parse('${AppConstants.baseUrl}/silvercollection/$id');

    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;

    if (filePath != null || fileBytes != null) {
      if (kIsWeb && fileBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          fileBytes,
          filename: 'updated.jpg',
        ));
      } else if (filePath != null) {
        request.files.add(await http.MultipartFile.fromPath('image', filePath));
      }
    }

    final response = await request.send();
    return response.statusCode == 200;
  }

  // ❌ DELETE
  static Future<bool> deleteCollection(String id) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/silvercollection/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode == 200;
  }
}
