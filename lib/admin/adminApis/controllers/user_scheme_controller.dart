import 'package:get/get.dart';
import '../models/user_scheme_model.dart';
import '../services/user_scheme_service.dart';

class UserSchemeController extends GetxController {
  var fullList = <UserSchemeModel>[].obs;
  var filteredList = <UserSchemeModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var selectedFilter = 'Name'.obs;
  var searchText = ''.obs;

  bool hasFetched = false;

  @override
  void onInit() {
    super.onInit();
    if (!hasFetched) {
      // fetchSchemes();
    }

    debounce(searchText, (_) => applyFilter(), time: const Duration(milliseconds: 300));
    ever(selectedFilter, (_) => applyFilter());
  }

  // Reset filter and search input
  void resetFilters() {
    searchText.value = '';
    selectedFilter.value = 'Name';
    filteredList.value = fullList;
  }

  void fetchSchemes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await UserSchemeService.fetchAllSchemes();
      fullList.value = data;
      filteredList.value = data;
      hasFetched = true;
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
      filteredList.value = fullList.where((scheme) {
        switch (filter) {
          case 'Name':
            return scheme.user?.name.toLowerCase().contains(query) ?? false;
          case 'Mobile':
            return scheme.user?.mobile.toLowerCase().contains(query) ?? false;
          case 'Plan':
            return scheme.schemeType.toLowerCase().contains(query);
          default:
            return false;
        }
      }).toList();
    }
  }

  @override
  void onClose() {
    resetFilters(); // clear search and filter when controller is removed
    super.onClose();
  }
}
