class UserModel {
  final String id;
  final String name;
  final String username;
  final String mobile;
  final String role;
  final String aadharImageUrl;
  final String aadharNumber;
  final String accountNo;
  final String address;
  final String ifsc;
  final int wallet;
  final String? referrerId;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.mobile,
    required this.role,
    required this.aadharImageUrl,
    required this.aadharNumber,
    required this.accountNo,
    required this.address,
    required this.ifsc,
    required this.wallet,
    required this.referrerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      mobile: json['mobile'] ?? '',
      role: json['role'] ?? '',
      aadharImageUrl: json['aadharImageUrl'] ?? '',
      aadharNumber: json['aadharNumber'] ?? '',
      accountNo: json['accountNo'] ?? '',
      address: json['address'] ?? '',
      ifsc: json['ifsc'] ?? '',
      wallet: json['wallet'] ?? 0,
      referrerId: json['referrerId'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
