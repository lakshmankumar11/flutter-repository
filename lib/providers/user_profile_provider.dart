// providers/user_profile_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user_profile_model.dart';
import '../views/config/constantsApiBaseUrl.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile();
  UserProfile get userProfile => _userProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEdit = false;
  bool get isEdit => _isEdit;

  String? _userId;
  String get userId => _userId ?? '';

  String? _token;
  String get token => _token ?? '';

  File? _profileImage;
  File? get profileImage => _profileImage;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  double _walletBalance = 0.0;
String _referralCode = '';

double get walletBalance => _walletBalance;
String get referralCode => _referralCode;

  // Dropdown options
  final List<String> schemeTypes = ['Fixed Plan', 'Flexible Plan'];
  final List<String> metals = ['Gold', 'Silver'];
  final List<String> frequencies = ['Daily', 'Weekly', 'Monthly'];
  final List<String> durations = ['6 Months', '1 Year', '2 Years'];

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void setProfileImage(File? image) {
    _profileImage = image;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Initializes token and userId from shared preferences
  Future<bool> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      _userId = prefs.getString('user_id');

      if (_token == null || JwtDecoder.isExpired(_token!)) {
        setError("Session expired. Please log in again.");
        return false;
      }

      return true;
    } catch (e) {
      setError("Authentication error: $e");
      return false;
    }
  }

  /// Fetch user profile by ID from backend
  Future<void> fetchUserProfile() async {
    setLoading(true);
    clearError();

    try {
      final isAuthValid = await initializeAuth();
      if (!isAuthValid) return;

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/user/profile/$_userId'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['user'];
        _userProfile = UserProfile.fromJson(data);
        _isEdit = true;

_walletBalance = data['walletBalance']?.toDouble() ?? 0.0;
_referralCode = data['referralCode'] ?? '';





        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_profile_complete', _userProfile.isProfileComplete);
      } else {
        setError("Failed to fetch profile (${response.statusCode})");
      }
    } catch (e) {
      setError("Error fetching profile: $e");
    } finally {
      setLoading(false);
    }
  }

  /// Save or update user profile
  Future<bool> saveProfile({
    required String name,
    required String username,
    required String address,
    required String mobile,
    required String aadharNumber,
     required String referralCode,
    required String accountNo,
    required String ifsc,

   
  }) async {
    setLoading(true);
    clearError();

    try {
      final isAuthValid = await initializeAuth();
      if (!isAuthValid) return false;

      final uri = Uri.parse(
        '${AppConstants.baseUrl}/user/profile${_isEdit ? '/$_userId' : ''}',
      );

      final request = http.MultipartRequest(_isEdit ? 'PUT' : 'POST', uri);
      request.headers['Authorization'] = 'Bearer $_token';

      request.fields['name'] = name;
      request.fields['username'] = username;
      request.fields['address'] = address;
      request.fields['mobile'] = mobile;
      request.fields['aadharNumber'] = aadharNumber;
      request.fields['accountNo'] = accountNo;
      request.fields['ifsc'] = ifsc;
      request.fields['usedReferralCode'] = referralCode;

// Include referral code if this is the first time it's being used
if (!_isEdit || (_userProfile.usedReferralCode == null || _userProfile.usedReferralCode!.isEmpty)) {
  if (referralCode.isNotEmpty) {
    request.fields['usedReferralCode'] = referralCode;
  }
}




      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'aadharImage',
          _profileImage!.path,
        ));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final profileJson = json.decode(responseBody)['user'];
        _userProfile = UserProfile.fromJson(profileJson);
        _isEdit = true;
        return true;
      } else {
        setError("Failed to save profile: ${response.reasonPhrase ?? responseBody}");
        return false;
      }
    } catch (e) {
      setError("Error saving profile: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Add a new blank scheme locally
  void addNewScheme() {
    final newScheme = UserScheme(
      schemeType: 'Fixed Plan',
      metal: 'Gold',
      frequency: 'Monthly',
      duration: '1 Year',
      monthlyAmount: 0.0,
      oneTimeAmount: 0.0,
      createdAt: DateTime.now().toIso8601String(),
    );

    final updatedSchemes = List<UserScheme>.from(_userProfile.schemes)..add(newScheme);
    _userProfile = _userProfile.copyWith(schemes: updatedSchemes);
    notifyListeners();
  }

  void updateScheme(int index, UserScheme updatedScheme) {
    if (index >= 0 && index < _userProfile.schemes.length) {
      final updatedSchemes = List<UserScheme>.from(_userProfile.schemes);
      updatedSchemes[index] = updatedScheme;
      _userProfile = _userProfile.copyWith(schemes: updatedSchemes);
      notifyListeners();
    }
  }

  void deleteScheme(int index) {
    if (index >= 0 && index < _userProfile.schemes.length) {
      final updatedSchemes = List<UserScheme>.from(_userProfile.schemes)..removeAt(index);
      _userProfile = _userProfile.copyWith(schemes: updatedSchemes);
      notifyListeners();
    }
  }

  Future<bool> saveScheme(int index) async {
    // Extend here to call `/api/v1/scheme` backend endpoint.
    try {
      return true;
    } catch (e) {
      setError("Error saving scheme: $e");
      return false;
    }
  }

  void resetScheme(int index) {
    fetchUserProfile(); // reloads schemes
  }

  void updateSchemeField(int index, String field, dynamic value) {
    if (index < 0 || index >= _userProfile.schemes.length) return;

    final scheme = _userProfile.schemes[index];
    UserScheme updatedScheme;

    switch (field) {
      case 'schemeType':
        updatedScheme = scheme.copyWith(schemeType: value);
        break;
      case 'metal':
        updatedScheme = scheme.copyWith(metal: value);
        break;
      case 'frequency':
        updatedScheme = scheme.copyWith(frequency: value);
        break;
      case 'duration':
        updatedScheme = scheme.copyWith(duration: value);
        break;
      case 'monthlyAmount':
        updatedScheme = scheme.copyWith(monthlyAmount: value);
        break;
      case 'oneTimeAmount':
        updatedScheme = scheme.copyWith(oneTimeAmount: value);
        break;
      default:
        return;
    }

    updateScheme(index, updatedScheme);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
