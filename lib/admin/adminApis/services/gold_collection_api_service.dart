import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/gold_collection_model.dart';
import '../../../views/config/constantsApiBaseUrl.dart';

class CollectionApiService {
  // 🔐 Get token from local storage
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // 📥 GET all collections
  static Future<List<Collection>> getCollections() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/goldcollection'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Collection.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load collections');
    }
  }

  // 🆕 POST: Add collection (not used directly in UI)
  static Future<bool> addCollection(Collection collection) async {
    final token = await _getToken();
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/goldcollection'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(collection.toJson()),
    );
    return res.statusCode == 201;
  }

  // 🆕 POST: Add collection with image
  static Future<bool> addCollectionWithImage({
    required String title,
    required String description,
    required String filePath,
    Uint8List? fileBytes,
  }) async {
    final token = await _getToken();
    var uri = Uri.parse('${AppConstants.baseUrl}/goldcollection');

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

  // 🔄 PUT: Update collection without image
  static Future<bool> updateCollection(String id, Collection collection) async {
    final token = await _getToken();
    final res = await http.put(
      Uri.parse('${AppConstants.baseUrl}/goldcollection/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(collection.toJson()),
    );
    return res.statusCode == 200;
  }

  // 🔄 PUT: Update collection with image
  static Future<bool> updateCollectionWithImage({
    required String id,
    required String title,
    required String description,
    String? filePath,
    Uint8List? fileBytes,
  }) async {
    final token = await _getToken();
    final uri = Uri.parse('${AppConstants.baseUrl}/goldcollection/$id');

    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;

    // Optional image update
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

  // ❌ DELETE: Remove a collection
  static Future<bool> deleteCollection(String id) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/goldcollection/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode == 200;
  }
}
