import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/widgets/GlobalRefreshButton.dart';
import '../../controller/OrderController.dart';
import './transaction_card.dart';
import '../../utils/refresh_helpers.dart';

class OrderHistoryPage extends StatelessWidget {
  OrderHistoryPage({Key? key}) : super(key: key) {
    orderController.fetchOrders(); // Fetch orders on load
  }

  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    final Color goldColor = const Color(0xFFFFD700); // Gold
    final Color backgroundColor = const Color(0xFFFFFDF3); // Light cream background

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: goldColor,
          title: Text(
            'order_history'.tr, // Translated
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 4,
          actions: [
            RefreshIconButton(
              onRefresh: () async => orderController.fetchOrders(),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.white,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'fixed_plan'.tr), // Translated
              Tab(text: 'flexible_plan'.tr), // Translated
            ],
          ),
        ),
        body: Obx(() {
          if (orderController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          if (orderController.error.isNotEmpty) {
            return Center(
              child: Text(
                orderController.error.value,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final allTransactions = orderController.transactions;
          final fixedTransactions = allTransactions
              .where((tx) => tx.scheme == 'fixed_plan')
              .toList();
          final flexiTransactions = allTransactions
              .where((tx) => tx.scheme == 'flexi_plan')
              .toList();

          return RefreshIndicator(
            onRefresh: () => handleGlobalRefresh(context, refreshOrders: true),
            child: TabBarView(
              children: [
                _buildTransactionList(
                    fixedTransactions, 'no_fixed_history'.tr), // Translated
                _buildTransactionList(
                    flexiTransactions, 'no_flexible_history'.tr), // Translated
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Builds list of transactions or a fallback view
  Widget _buildTransactionList(List transactions, String emptyMessage) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded,
                color: Colors.grey.shade400, size: 60),
            const SizedBox(height: 10),
            Text(
              emptyMessage,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: transactions.length,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TransactionCard(transaction: transactions[index]),
        );
      },
    );
  }
}
