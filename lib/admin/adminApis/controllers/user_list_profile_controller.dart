import 'package:get/get.dart';
import '../models/user_list_profile_model.dart';
import '../services/user_list_profile_services.dart';

class AdminUserController  extends GetxController {
  var userList = <UserModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var selectedFilter = 'Name'.obs;
  var searchText = ''.obs;

  /// ✅ Add this field
  bool hasFetched = false;

  List<UserModel> get filteredList {
    if (searchText.isEmpty) return userList;

    final query = searchText.value.toLowerCase();

    return userList.where((user) {
      switch (selectedFilter.value) {
        case 'Name':
          return user.name.toLowerCase().contains(query);
        case 'Mobile':
          return user.mobile.toLowerCase().contains(query);
        case 'Address':
          return user.address.toLowerCase().contains(query);
        default:
          return true;
      }
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // Optional: You can call loadUsers() here if needed
  }

  // Reset filter and search input
  void resetFilters() {
    searchText.value = '';
    selectedFilter.value = 'Name';
  }

  /// ✅ Fetch all users from API (only if not already fetched)
Future<void> loadUsers({bool forceRefresh = false}) async {
  if (hasFetched && !forceRefresh) return; // Skip only if not forced

  isLoading.value = true;
  try {
    final users = await UserService.fetchAllUsers();
    users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    userList.assignAll(users);
    hasFetched = true;
    errorMessage.value = '';
  } catch (e) {
    errorMessage.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}


  /// ✅ Clears only the search field (used when coming back to this page)
  void resetSearch() {
    searchText.value = '';
  }
}
