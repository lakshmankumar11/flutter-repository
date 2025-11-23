class GoldSalesModel {
  final double totalGrams;
  final double totalKilograms;
  final int totalAmount;
  final double thisMonthGrams;
  final double thisMonthKilograms;
  final int thisMonthAmount;

  GoldSalesModel({
    required this.totalGrams,
    required this.totalKilograms,
    required this.totalAmount,
    required this.thisMonthGrams,
    required this.thisMonthKilograms,
    required this.thisMonthAmount,
  });

  factory GoldSalesModel.fromJson(Map<String, dynamic> json) {
    return GoldSalesModel(
      totalGrams: (json['totalGoldSales']['grams'] ?? 0).toDouble(),
      totalKilograms: (json['totalGoldSales']['kilograms'] ?? 0).toDouble(),
      totalAmount: (json['totalGoldSales']['amount'] ?? 0).toInt(),
      thisMonthGrams: (json['thisMonthSales']['grams'] ?? 0).toDouble(),
      thisMonthKilograms: (json['thisMonthSales']['kilograms'] ?? 0).toDouble(),
      thisMonthAmount: (json['thisMonthSales']['amount'] ?? 0).toInt(),
    );
  }
}
