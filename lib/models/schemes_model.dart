class SchemeModel {
  final String? id;
  final String schemeType;
  final String metal;
  final int? duration;           // Required for both
  final int? monthlyAmount;      // For fixed_plan
  final int? oneTimeAmount;      // For flexi_plan

  SchemeModel({
    this.id,
    required this.schemeType,
    required this.metal,
    this.duration,
    this.monthlyAmount,
    this.oneTimeAmount,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      id: json['_id']?.toString(),
      schemeType: json['schemeType'] ?? '',
      metal: json['metal'] ?? '',
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse('${json['duration']}'),
      monthlyAmount: json['monthlyAmount'] is int
          ? json['monthlyAmount']
          : int.tryParse('${json['monthlyAmount']}'),
      oneTimeAmount: json['oneTimeAmount'] is int
          ? json['oneTimeAmount']
          : int.tryParse('${json['oneTimeAmount']}'),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "schemeType": schemeType,
      "metal": metal,
    };

    if (duration != null) data["duration"] = duration;

    if (schemeType == 'fixed_plan') {
      if (monthlyAmount != null) data["monthlyAmount"] = monthlyAmount;
    } else if (schemeType == 'flexi_plan') {
      if (oneTimeAmount != null) data["oneTimeAmount"] = oneTimeAmount;
    }

    return data;
  }
}
