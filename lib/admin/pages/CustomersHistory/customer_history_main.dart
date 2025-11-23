import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/widgets/GlobalRefreshButton.dart';
import '../../adminApis/controllers/payment_history_controller.dart';

class UserPaymentHistoryMainPage extends StatefulWidget {
  const UserPaymentHistoryMainPage({super.key});

  @override
  State<UserPaymentHistoryMainPage> createState() =>
      _UserPaymentHistoryMainPageState();
}

class _UserPaymentHistoryMainPageState
    extends State<UserPaymentHistoryMainPage> {
  final PaymentHistoryController controller = Get.put(PaymentHistoryController());
  late TextEditingController _searchController;
  final expandedList = <int, RxBool>{};

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController();

    _searchController.addListener(() {
      controller.searchText.value = _searchController.text;
    });

    controller.resetFilters();
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
        title: const Text("All Payments"),
        backgroundColor: Colors.amber[800],
        actions: [
          RefreshIconButton(
            onRefresh: () async => controller.fetchPayments(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSearchRow(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (controller.filteredList.isEmpty) {
                return const Center(child: Text("No payments found."));
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final user = controller.filteredList[index];
                    expandedList[index] ??= false.obs;

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("📱 Mobile: ${user.mobile}"),
                                  Text("🪪 Aadhar: ${user.aadharNumber}"),
                                ],
                              ),
                              trailing: Obx(() => IconButton(
                                    icon: Icon(
                                      expandedList[index]!.value
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                    onPressed: () => expandedList[index]!.toggle(),
                                  )),
                            ),
                            Obx(() => AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 300),
                                  crossFadeState: expandedList[index]!.value
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Divider(),
                                      ...user.payments.map((payment) {
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "📄 Plan Type: ${payment.schemeType}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text("🔔 Metal: ${payment.metal}"),
                                              Text("📅 Month: ${payment.month}"),
                                              Text("💰 Amount Paid: ₹${payment.amountPaid}"),
                                              Text("⚖️ Gram Weight: ${payment.gramWeight}g"),
                                              Text("🕒 Payment Date: ${payment.paymentDate}"),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                  secondChild: const SizedBox.shrink(),
                                )),
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
                    value: controller.selectedFilter.value,
                    items: ['Name', 'Mobile', 'Plan']
                        .map((filter) => DropdownMenuItem(
                              value: filter,
                              child: Text("By $filter"),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedFilter.value = val;
                      }
                    },
                  ),
                ),
              )),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Colors.grey.shade400, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
