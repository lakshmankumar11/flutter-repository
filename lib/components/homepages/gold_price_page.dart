import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../../providers/metal_rate_provider.dart';

class GoldPriceCard extends StatefulWidget {
  const GoldPriceCard({super.key});

  @override
  State<GoldPriceCard> createState() => _GoldPriceCardState();
}

class _GoldPriceCardState extends State<GoldPriceCard> {
  bool _localLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    setState(() => _localLoading = true);
    await Provider.of<GoldRateProvider>(context, listen: false).fetchMetalPrices();
    if (mounted) setState(() => _localLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoldRateProvider>(context);

    if (provider.error != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return GestureDetector(
      onTap: _fetchData, // Optional manual refresh
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade700, Colors.amber.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: _localLoading
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              )
            : ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                leading: SizedBox(
                  width: 70,
                  height: 70,
                  child: Lottie.asset(
                    'assets/animations/goldanimation.json',
                    repeat: true,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  'gold_24k'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  provider.gold999Rate != null
                      ? "₹${provider.gold999Rate!.toStringAsFixed(2)} ${'per_gram'.tr}"
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
