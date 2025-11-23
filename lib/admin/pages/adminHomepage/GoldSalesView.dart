import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../adminApis/controllers/gold_sales_controller.dart';

class GoldSalesView extends StatelessWidget {
  final GoldSalesController controller = Get.put(GoldSalesController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = controller.goldSalesData.value;

      if (data == null) {
        return const Center(child: Text("No data found"));
      }

      return Column(
        children: [
          Text("Total Grams: ${data.totalGrams}"),
          Text("Total Kilograms: ${data.totalKilograms}"),
          Text("Total Amount: ₹${data.totalAmount}"),
          const Divider(),
          Text("This Month Grams: ${data.thisMonthGrams}"),
          Text("This Month Kilograms: ${data.thisMonthKilograms}"),
          Text("This Month Amount: ₹${data.thisMonthAmount}"),
        ],
      );
    });
  }
}
