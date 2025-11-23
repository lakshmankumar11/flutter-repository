import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gold_purchase_app/payment/razorpay_payment.dart';
import 'package:provider/provider.dart';
import '../../../models/schemes_model.dart';
import '../../../providers/metal_rate_provider.dart';

class FlexiPlanPaymentPage extends StatefulWidget {
  final int amountInPaise;
  final double grams;
  final String schemeId;

  const FlexiPlanPaymentPage({
    Key? key,
    required this.amountInPaise,
    required this.grams,
    required this.schemeId,
  }) : super(key: key);

  @override
  State<FlexiPlanPaymentPage> createState() => _FlexiPlanPaymentPageState();
}

class _FlexiPlanPaymentPageState extends State<FlexiPlanPaymentPage> {
  bool _localLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchGoldRate());
  }

  Future<void> _fetchGoldRate() async {
    setState(() => _localLoading = true);
    await Provider.of<GoldRateProvider>(
      context,
      listen: false,
    ).fetchMetalPrices();
    if (mounted) setState(() => _localLoading = false);
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SchemeModel scheme = Get.arguments;
    final goldRateProvider = Provider.of<GoldRateProvider>(context);
    final double goldRate = goldRateProvider.gold999Rate ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flexi Plan Payment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFFD700),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: _localLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Scheme Details
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Scheme Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildRow("scheme_type.".tr, scheme.schemeType),
                          _buildRow("metal.".tr, scheme.metal),
                          _buildRow("duration.".tr, "${scheme.duration} months"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Plan Summary
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF176), Color(0xFFFFD54F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Plan Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildRow(
                            "Total Purchase Amount",
                            "₹${(widget.amountInPaise / 100).toStringAsFixed(2)}",
                          ),
                          _buildRow(
                            "Gold Rate",
                            "₹${goldRate.toStringAsFixed(2)} / gram",
                          ),
                          _buildRow(
                            "Gold You Get",
                            "${widget.grams.toStringAsFixed(2)} grams",
                          ),
                          _buildRow("Plan Type", "Flexi Payment"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Confirm Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RazorpayPage(
                                amountInPaise: widget.amountInPaise.toInt(),
                                schemeId: widget.schemeId,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.payment, color: Colors.black),
                        label: const Text(
                          'Pay Plan Now',
                          style: TextStyle(color: Colors.black),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
