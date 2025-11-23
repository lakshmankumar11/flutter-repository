import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_details_controller.dart';
import '../../models/user_details_model.dart';

class HomePromoPanel extends StatelessWidget {
  HomePromoPanel({super.key});

  final UserDetailsController userDetailsController = Get.put(UserDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (userDetailsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (userDetailsController.error.isNotEmpty) {
        return Center(child: Text(userDetailsController.error.value));
      }

      final user = userDetailsController.userDetails.value;
      if (user == null) {
        return const Center(child: Text('No user data found'));
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: _atmStyleCard(user),
      );
    });
  }

  Widget _atmStyleCard(UserDetailsModel user) {
    final overall = user.overallSummary;
    final fixed = overall.fixedPlan;
    final flexi = overall.flexiPlan;
    final isActive = user.status?.toLowerCase() == "active";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF512F), Color.fromARGB(255, 231, 216, 3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name and Mobile
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Text(
                  user.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    user.mobile,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Status
          if (user.status != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? Colors.green[600] : Colors.red[600],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "STATUS: ${user.status?.toUpperCase() ?? "UNKNOWN"}",
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),

          const SizedBox(height: 12),

          /// Customer ID and Account No
          if (user.customerId != null && user.customerId!.isNotEmpty)
            Text("Customer ID: ${user.customerId}", style: const TextStyle(fontSize: 14, color: Colors.white70)),
          if (user.accountNo != null && user.accountNo!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text("Account No: ${user.accountNo}", style: const TextStyle(fontSize: 14, color: Colors.white70)),
            ),

          const SizedBox(height: 16),

          /// Total Paid & Gold Cards
         /// Total Paid (Top) & Total Gold (Bottom)
Column(
  children: [
    _highlightCard(
      icon: Icons.currency_rupee_rounded,
      label: "Total Paid",
      value: "₹${overall.totalAmountPaid.toStringAsFixed(2)}",
      color: Colors.greenAccent[100],
    ),
    const SizedBox(height: 12),
    _highlightCard(
      icon: Icons.savings_outlined,
      label: "Total Gold",
      value: "${overall.totalGrams.toStringAsFixed(3)}g",
      color: Colors.amber[200],
    ),
  ],
),

          const SizedBox(height: 20),

          /// Plan Breakdown
          Row(
            children: [
              Expanded(
                child: _infoColumn(
                  "Fixed Plan",
                  "Gold: ${fixed.totalGrams.toStringAsFixed(3)}g\n₹${fixed.totalAmountPaid.toStringAsFixed(2)}",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoColumn(
                  "Flexi Plan",
                  "Gold: ${flexi.totalGrams.toStringAsFixed(3)}g\n₹${flexi.totalAmountPaid.toStringAsFixed(2)}",
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Gold Saved Circular View
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow[600],
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${overall.totalGrams.toStringAsFixed(3)}g",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Total Gold Saved", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _highlightCard({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: color ?? Colors.white24,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
