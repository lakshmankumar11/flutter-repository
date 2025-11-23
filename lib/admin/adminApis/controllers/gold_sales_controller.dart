import 'package:get/get.dart';
import '../models/gold_sales_model.dart';
import '../services/gold_sale_api_services.dart';

class GoldSalesController extends GetxController {
  var isLoading = true.obs;
  var goldSalesData = Rxn<GoldSalesModel>();

  /// ✅ Add this flag
  bool hasFetched = false;

  @override
  void onInit() {
    // Optional: call fetchGoldSalesData() here if you want
    super.onInit();
  }

  /// ✅ Modified function to run only once
  void fetchGoldSalesData() async {
    if (hasFetched) return; // ✅ Prevent refetching if already fetched

    isLoading.value = true;
    final data = await ApiService.fetchGoldSales();
    if (data != null) {
      goldSalesData.value = data;
      hasFetched = true; // ✅ Mark as fetched
    }
    isLoading.value = false;
  }
}
