import 'package:get/get.dart';
import '../models/payment_history_model.dart';
import '../services/payment_history_service.dart';

class PaymentHistoryController extends GetxController {
  var fullList = <PaymentHistoryModel>[].obs;
  var filteredList = <PaymentHistoryModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var selectedFilter = 'Name'.obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
    debounce(searchText, (_) => applyFilter(), time: const Duration(milliseconds: 300));
    ever(selectedFilter, (_) => applyFilter());
  }


 // Reset filter and search input
  void resetFilters() {
    searchText.value = '';
    selectedFilter.value = 'Name';
    filteredList.value = fullList;
  }
  void fetchPayments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await PaymentHistoryService.fetchAllPayments();
      fullList.value = data;
      filteredList.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter() {
    final query = searchText.value.toLowerCase();
    final filter = selectedFilter.value;

    if (query.isEmpty) {
      filteredList.value = fullList;
    } else {
      filteredList.value = fullList.where((history) {
        switch (filter) {
          case 'Name':
            return history.name.toLowerCase().contains(query);
          case 'Mobile':
            return history.mobile.toLowerCase().contains(query);
          case 'Plan':
            return history.payments.any(
              (p) => p.schemeType.toLowerCase().contains(query),
            );
          default:
            return false;
        }
      }).toList();
    }
  }
}
