class UserDetailsModel {
  final String id;
  final String name;
  final String? username;
  final String mobile;
  final String? customerId;
  final String? accountNo;
  final String? status;
  final List<Scheme> schemes;
  final List<MonthlySummary> monthlySummary;
  final OverallSummary overallSummary;

  UserDetailsModel({
    required this.id,
    required this.name,
    this.username,
    required this.mobile,
    this.customerId,
      this.accountNo,
      this.status,
    required this.schemes,
    required this.monthlySummary,
    required this.overallSummary,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return UserDetailsModel(
      id: user['_id'],
      name: user['name'] ?? '',
      username: user['username'],
      mobile: user['mobile'] ?? '',
      customerId: user['customerId'],
      accountNo: user['accountNo'],
      status: user['status'],
      schemes: (json['schemes'] as List<dynamic>)
          .map((e) => Scheme.fromJson(e))
          .toList(),
      monthlySummary: (json['monthlySummary'] as List<dynamic>)
          .map((e) => MonthlySummary.fromJson(e))
          .toList(),
      overallSummary: OverallSummary.fromJson(json['overallSummary']),
    );
  }
}

class Scheme {
  final String schemeType;
  final String metal;
  final int duration;
  final int? monthlyAmount;

  Scheme({
    required this.schemeType,
    required this.metal,
    required this.duration,
    this.monthlyAmount,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      schemeType: json['schemeType'] ?? '',
      metal: json['metal'] ?? '',
      duration: json['duration'] ?? 0,
      monthlyAmount: json['monthlyAmount'], // Can be null
    );
  }
}

class MonthlySummary {
  final String? id;
  final double totalAmountPaid;
  final double totalGrams;
  final List<Payment> payments;

  MonthlySummary({
    this.id,
    required this.totalAmountPaid,
    required this.totalGrams,
    required this.payments,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      id: json['_id'],
      totalAmountPaid: (json['totalAmountPaid'] ?? 0).toDouble(),
      totalGrams: (json['totalGrams'] ?? 0).toDouble(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => Payment.fromJson(e))
          .toList(),
    );
  }
}

class Payment {
  final double amountPaid;
  final double gramWeight;
  final String paymentDate;
  final String metal;
  final String schemeType;

  Payment({
    required this.amountPaid,
    required this.gramWeight,
    required this.paymentDate,
    required this.metal,
    required this.schemeType,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amountPaid: (json['amountPaid'] ?? 0).toDouble(),
      gramWeight: (json['gramWeight'] ?? 0).toDouble(),
      paymentDate: json['paymentDate'] ?? '',
      metal: json['metal'] ?? '',
      schemeType: json['schemeType'] ?? '',
    );
  }
}

class OverallSummary {
  final double totalAmountPaid;
  final double totalGrams;
  final PlanSummary fixedPlan;
  final PlanSummary flexiPlan;

  OverallSummary({
    required this.totalAmountPaid,
    required this.totalGrams,
    required this.fixedPlan,
    required this.flexiPlan,
  });

  factory OverallSummary.fromJson(Map<String, dynamic> json) {
    return OverallSummary(
      totalAmountPaid: (json['totalAmountPaid'] ?? 0).toDouble(),
      totalGrams: (json['totalGrams'] ?? 0).toDouble(),
      fixedPlan: PlanSummary.fromJson(json['fixed_plan']),
      flexiPlan: PlanSummary.fromJson(json['flexi_plan']),
    );
  }
}

class PlanSummary {
  final double totalAmountPaid;
  final double totalGrams;

  PlanSummary({required this.totalAmountPaid, required this.totalGrams});

  factory PlanSummary.fromJson(Map<String, dynamic> json) {
    return PlanSummary(
      totalAmountPaid: (json['totalAmountPaid'] ?? 0).toDouble(),
      totalGrams: (json['totalGrams'] ?? 0).toDouble(),
    );
  }
}
