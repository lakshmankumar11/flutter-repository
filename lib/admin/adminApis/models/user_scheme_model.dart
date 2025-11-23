class UserWithSchemes {
  final String userId;
  final String name;
  final String mobile;
  final String aadharNumber;
  final List<UserSchemeModel> schemes;

  UserWithSchemes({
    required this.userId,
    required this.name,
    required this.mobile,
    required this.aadharNumber,
    required this.schemes,
  });

  factory UserWithSchemes.fromJson(Map<String, dynamic> json) {
    return UserWithSchemes(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      aadharNumber: json['aadharNumber'] ?? '',
      schemes: (json['schemes'] as List).map((e) {
        return UserSchemeModel.fromJson(e, userInfo: UserInfo(
          id: json['userId'] ?? '',
          name: json['name'] ?? '',
          mobile: json['mobile'] ?? '',
          aadharNumber: json['aadharNumber'] ?? '',
        ));
      }).toList(),
    );
  }
}

class UserSchemeModel {
  final String schemeType;
  final String metal;
  final int? monthlyAmount;
  final UserInfo user;

  UserSchemeModel({
    required this.schemeType,
    required this.metal,
    required this.monthlyAmount,
    required this.user,
  });

  factory UserSchemeModel.fromJson(Map<String, dynamic> json, {required UserInfo userInfo}) {
    return UserSchemeModel(
      schemeType: json['schemeType'] ?? '',
      metal: json['metal'] ?? '',
      monthlyAmount: json['monthlyAmount'],
      user: userInfo,
    );
  }
}

class UserInfo {
  final String id;
  final String name;
  final String mobile;
  final String aadharNumber;

  UserInfo({
    required this.id,
    required this.name,
    required this.mobile,
    required this.aadharNumber,
  });
}
