// models/user_profile_model.dart
class UserScheme {
  String? id;
  String schemeType;
  String metal;
  String frequency;
  String duration;
  double monthlyAmount;
  double oneTimeAmount;
  String? createdAt;

  UserScheme({
    this.id,
    required this.schemeType,
    required this.metal,
    required this.frequency,
    required this.duration,
    required this.monthlyAmount,
    required this.oneTimeAmount,
    this.createdAt,
  });

  factory UserScheme.fromJson(Map<String, dynamic> json) {
    return UserScheme(
      id: json['_id'],
      schemeType: json['schemeType'] ?? 'Fixed Plan',
      metal: json['metal'] ?? 'Gold',
      frequency: json['frequency'] ?? 'Monthly',
      duration: json['duration'] ?? '1 Year',
      monthlyAmount: (json['monthlyAmount'] ?? 0).toDouble(),
      oneTimeAmount: (json['oneTimeAmount'] ?? 0).toDouble(),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'schemeType': schemeType,
      'metal': metal,
      'frequency': frequency,
      'duration': duration,
      'monthlyAmount': monthlyAmount,
      'oneTimeAmount': oneTimeAmount,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  UserScheme copyWith({
    String? id,
    String? schemeType,
    String? metal,
    String? frequency,
    String? duration,
    double? monthlyAmount,
    double? oneTimeAmount,
    String? createdAt,
  }) {
    return UserScheme(
      id: id ?? this.id,
      schemeType: schemeType ?? this.schemeType,
      metal: metal ?? this.metal,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      oneTimeAmount: oneTimeAmount ?? this.oneTimeAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserProfile {
  String? id;
  String? name;
  String? username;
  String? address;
  String? mobile;
  String? aadharNumber;
  String? accountNo;
  String? ifsc;
  String? imageUrl;
  List<UserScheme> schemes;
  bool isProfileComplete;
  String? usedReferralCode;
    String? referralCode; // ✅ NEW
  double wallet; // ✅ NEW

  UserProfile({
    this.id,
    this.name,
    this.username,
    this.address,
    this.mobile,
    this.aadharNumber,
    this.accountNo,
    this.ifsc,
    this.imageUrl,
    this.schemes = const [],
    this.isProfileComplete = false,
    this.referralCode,
    this.wallet = 0.0, // default value
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    List<UserScheme> schemesList = [];
    if (json['schemes'] != null) {
      schemesList = (json['schemes'] as List)
          .map((scheme) => UserScheme.fromJson(scheme))
          .toList();
    }

    return UserProfile(
      id: json['_id'],
      name: json['name'],
      username: json['username'],
      address: json['address'],
      mobile: json['mobile'],
      aadharNumber: json['aadharNumber'],
      accountNo: json['accountNo'],
      ifsc: json['ifsc'],
      imageUrl: json['aadharImageUrl'],
      schemes: schemesList,
      referralCode: json['referralCode'], // ✅
      wallet: (json['wallet'] ?? 0).toDouble(), // ✅

      isProfileComplete: json['name'] != null &&
          json['username'] != null &&
          json['address'] != null &&
          json['mobile'] != null &&
          json['aadharNumber'] != null &&
          json['accountNo'] != null &&
          json['ifsc'] != null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (address != null) 'address': address,
      if (mobile != null) 'mobile': mobile,
      if (aadharNumber != null) 'aadharNumber': aadharNumber,
      if (accountNo != null) 'accountNo': accountNo,
      if (ifsc != null) 'ifsc': ifsc,
      if (imageUrl != null) 'aadharImageUrl': imageUrl,
         if (referralCode != null) 'referralCode': referralCode, // ✅
      'wallet': wallet, // ✅
      'schemes': schemes.map((scheme) => scheme.toJson()).toList(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? username,
    String? address,
    String? mobile,
    String? aadharNumber,
    String? accountNo,
    String? ifsc,
    String? imageUrl,
    List<UserScheme>? schemes,
    bool? isProfileComplete,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      address: address ?? this.address,
      mobile: mobile ?? this.mobile,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      accountNo: accountNo ?? this.accountNo,
      ifsc: ifsc ?? this.ifsc,
      imageUrl: imageUrl ?? this.imageUrl,
      schemes: schemes ?? this.schemes,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}