import 'package:intl/intl.dart';

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final double gramsPurchased;
  final String metal;
  final String scheme;
  final DateTime date;
  final String paymentMonth;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.gramsPurchased,
    required this.metal,
    required this.scheme,
    required this.date,
    required this.paymentMonth,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateFormat('dd-MM-yyyy').parse(json['paymentDate'] ?? '');
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return TransactionModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amountPaid'] ?? 0).toDouble(),
      gramsPurchased: (json['gramWeight'] ?? 0).toDouble(),
      metal: json['metal'] ?? '',
      scheme: json['schemeType'] ?? '',
      date: parsedDate,
      paymentMonth: json['month'] ?? '',
    );
  }
}
