import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/image_model.dart';
import '../views/config/constantsApiBaseUrl.dart';

class ApiService {
  /// 🔐 Get Auth Token
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// 📦 Get Admin ID
  static Future<String?> _getAdminId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  /// ✅ Fetch all images (flat list with groupId field)
  static Future<List<ImageItem>> fetchImages() async {
    final url = Uri.parse('${AppConstants.baseUrl}/admin/images');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      final List<ImageItem> allImages = [];

      for (var group in data) {
        final groupId = group['_id'];
        final List nestedImages = group['images'] ?? [];

        for (var img in nestedImages) {
          allImages.add(ImageItem.fromJson(img, groupId));
        }
      }

      return allImages;
    } else {
      throw Exception('Failed to load images');
    }
  }

 static Future<bool> uploadImage({
  File? file,
  Uint8List? bytes,
  String? fileName,
}) async {
  final adminId = await _getAdminId();
  final token = await _getToken();
  if (adminId == null || token == null) return false;

  final uri = Uri.parse('${AppConstants.baseUrl}/admin/upload/$adminId');
  final request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = 'Bearer $token';

  try {
    if (kIsWeb && bytes != null && fileName != null) {
      final mimeType = lookupMimeType(fileName) ?? 'image/jpeg';
      request.files.add(http.MultipartFile.fromBytes(
        'images', // 👈 use same field name backend expects
        bytes,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ));
    } else if (file != null) {
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      request.files.add(await http.MultipartFile.fromPath(
        'images', // 👈 use same field name backend expects
        file.path,
        contentType: MediaType.parse(mimeType),
      ));
    } else {
      return false;
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
  
    return false;
  }
}


  /// ✏️ Update Single Image by ID (PUT)
  static Future<bool> updateSingleImage({
    required String imageId,
    File? file,
    Uint8List? bytes,
    String? fileName,
  }) async {
    final token = await _getToken();
    if (token == null) return false;

    final uri = Uri.parse('${AppConstants.baseUrl}/admin/upload/$imageId');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    if (kIsWeb && bytes != null && fileName != null) {
      final mimeType = lookupMimeType(fileName) ?? 'image/jpeg';
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ));
    } else if (file != null) {
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        file.path,
        contentType: MediaType.parse(mimeType),
      ));
    } else {
      return false;
    }

    final streamedResponse = await request.send();
    return streamedResponse.statusCode == 200;
  }

  /// 🗑 Delete Single Image by ID
  static Future<bool> deleteSingleImage(String imageId) async {
    final token = await _getToken();
    if (token == null) return false;

    final uri = Uri.parse('${AppConstants.baseUrl}/admin/upload/$imageId');
    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
