import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/widgets/GlobalRefreshButton.dart';
import '../../adminApis/controllers/user_scheme_controller.dart';
import '../../adminApis/models/user_scheme_model.dart';

class UserSchemePlanPageList extends StatefulWidget {
  const UserSchemePlanPageList({super.key});

  @override
  State<UserSchemePlanPageList> createState() => _UserSchemePlanPageListState();
}

class _UserSchemePlanPageListState extends State<UserSchemePlanPageList> {
  final UserSchemeController schemeController = Get.find<UserSchemeController>();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      schemeController.searchText.value = _searchController.text;
    });

    // Reset filter and search input every time this page is opened
    schemeController.resetFilters();
    
  // ✅ Only fetch once
  if (!schemeController.hasFetched) {
    schemeController.fetchSchemes();
  }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text("User Scheme Plans"),
        backgroundColor: Colors.amber[800],
        elevation: 0,
        actions: [
          RefreshIconButton(onRefresh: () async => schemeController.fetchSchemes()),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSearchRow(),
          Expanded(
            child: Obx(() {
              if (schemeController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (schemeController.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    schemeController.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (schemeController.filteredList.isEmpty) {
                return const Center(child: Text("No matching schemes found.", style: TextStyle(fontSize: 16)));
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: schemeController.filteredList.length,
                  itemBuilder: (context, index) {
                    UserSchemeModel scheme = schemeController.filteredList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scheme.user.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            Row(children: [
                              const Icon(Icons.phone, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text("Mobile: ${scheme.user.mobile}"),
                            ]),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.credit_card, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text("Aadhar: ${scheme.user.aadharNumber}"),
                            ]),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.description, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text("Plan Type: ${scheme.schemeType}"),
                            ]),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.stars, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text("Metal: ${scheme.metal}"),
                            ]),
                            if (scheme.monthlyAmount != null)
                              Row(children: [
                                const Icon(Icons.attach_money, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Monthly Amount: ₹${scheme.monthlyAmount}"),
                              ]),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSearchRow() {
    return Padding(
      padding: const EdgeInsets.all(12),
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
                    value: schemeController.selectedFilter.value,
                    items: ['Name', 'Mobile', 'Plan']
                        .map((filter) => DropdownMenuItem(
                              value: filter,
                              child: Text("By $filter"),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        schemeController.selectedFilter.value = val;
                      }
                    },
                  ),
                ),
              )),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() => TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search user schemes...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: schemeController.searchText.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              schemeController.searchText.value = '';
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.amber, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
