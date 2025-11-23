import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../adminApis/controllers/user_list_profile_controller.dart';
import '../../adminApis/models/user_list_profile_model.dart';
import 'package:gold_purchase_app/widgets/GlobalRefreshButton.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> with WidgetsBindingObserver {
  final AdminUserController  userController = Get.put(AdminUserController ());
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _searchController.addListener(() {
      userController.searchText.value = _searchController.text;
    });
 userController.resetFilters();
    // WidgetsBinding.instance.addObserver(this);

    
  // ✅ Fetch data only once when entering the page
  if (!userController.hasFetched) {
    userController.loadUsers();
  }
  }

  @override
  void dispose() {
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Optional: Keep search value or reset
      // userController.resetSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            "Users & Admins",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.amber[700],
          elevation: 4,
          actions: [
            RefreshIconButton(
              onRefresh: () async => await userController.loadUsers(),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Users"),
              Tab(text: "Admins"),
            ],
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            _buildFilterSearchRow(userController),
            Expanded(
              child: TabBarView(
                children: [
                  _buildUserList(userController, filterBy: "user"),
                  _buildUserList(userController, filterBy: "admin"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSearchRow(AdminUserController  controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedFilter.value,
                    items: ['Name', 'Mobile', 'Address']
                        .map((filter) => DropdownMenuItem(
                              value: filter,
                              child: Text("By $filter"),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.selectedFilter.value = val;
                    },
                  ),
                ),
              )),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search here...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(AdminUserController  controller, {required String filterBy}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      List<UserModel> filtered = controller.filteredList
          .where((user) => user.role.toLowerCase() == filterBy.toLowerCase())
          .toList();

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: const TextStyle(color: Colors.red),
          ),
        );
      } else if (filtered.isEmpty) {
        return const Center(child: Text("No matching users found."));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          UserModel user = filtered[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shadowColor: Colors.grey.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                user.name.isNotEmpty ? user.name : "No Name",
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "📱 ${user.mobile}\n🆔 ${user.id}",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                if (user.aadharImageUrl.isNotEmpty) ...[
                  _sectionLabel("Aadhar Image"),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      user.aadharImageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                _sectionLabel("User Details"),
                const SizedBox(height: 6),
                _buildInfo("Username", user.username),
                _buildInfo("Role", user.role),
                _buildInfo("Wallet", "₹${user.wallet}"),
                _buildInfo("Referrer ID", user.referrerId ?? "N/A"),
                const SizedBox(height: 12),
                _sectionLabel("Bank & Address"),
                const SizedBox(height: 6),
                _buildInfo("Aadhar No", user.aadharNumber),
                _buildInfo("Account No", user.accountNo),
                _buildInfo("IFSC", user.ifsc),
                _buildInfo("Address", user.address),
                const SizedBox(height: 12),
                _sectionLabel("Timestamps"),
                const SizedBox(height: 6),
                _buildInfo("Created At", user.createdAt),
                _buildInfo("Updated At", user.updatedAt),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.deepOrange,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
