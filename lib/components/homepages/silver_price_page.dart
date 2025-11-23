import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../providers/metal_rate_provider.dart';

class SilverPriceCard extends StatelessWidget {
  const SilverPriceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoldRateProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.error != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        provider.fetchMetalPrices(silent: true);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade700, Colors.grey.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          leading: Lottie.asset(
            'assets/lottie/coin_silver.json',
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          title: Text(
            'silver_999'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            provider.silver999Rate != null
                ? "₹${provider.silver999Rate!.toStringAsFixed(2)} ${'per_gram'.tr}"
                : 'rate_not_available'.tr,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
