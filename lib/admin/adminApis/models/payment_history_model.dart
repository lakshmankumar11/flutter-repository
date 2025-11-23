class PaymentHistoryModel {
  final String userId;
  final String name;
  final String mobile;
  final String aadharNumber;
  final List<Payment> payments;

  PaymentHistoryModel({
    required this.userId,
    required this.name,
    required this.mobile,
    required this.aadharNumber,
    required this.payments,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      aadharNumber: json['aadharNumber'] ?? '',
      payments: (json['payments'] as List<dynamic>? ?? [])
          .map((p) => Payment.fromJson(p))
          .toList(),
    );
  }
}

class Payment {
  final String schemeType;
  final String metal;
  final String month;
  final int amountPaid;
  final double gramWeight;
  final String paymentDate;

  Payment({
    required this.schemeType,
    required this.metal,
    required this.month,
    required this.amountPaid,
    required this.gramWeight,
    required this.paymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      schemeType: json['schemeType'] ?? '',
      metal: json['metal'] ?? '',
      month: json['month'] ?? '',
      amountPaid: (json['amountPaid'] ?? 0) is int
          ? json['amountPaid']
          : int.tryParse(json['amountPaid'].toString()) ?? 0,
      gramWeight: (json['gramWeight'] ?? 0).toDouble(),
      paymentDate: json['paymentDate'] ?? '',
    );
  }
}
