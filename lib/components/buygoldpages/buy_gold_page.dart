import 'package:flutter/material.dart';
import 'package:gold_purchase_app/payment/flexi_plan_payment.dart';
import 'package:provider/provider.dart';
import 'buy_Gold.dart';
import './gold_price_banner.dart';
import '../../providers/metal_rate_provider.dart';
import './schemes/SchemePage.dart';
import '../../services/schemes_api_services.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class BuyGoldPage extends StatefulWidget {
  const BuyGoldPage({Key? key}) : super(key: key);

  @override
  State<BuyGoldPage> createState() => _BuyGoldPageState();
}

class _BuyGoldPageState extends State<BuyGoldPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<GoldRateProvider>(context, listen: false).fetchMetalPrices();
    });
  }

  Future<void> _handleConfirm(double grams, double amount) async {
    try {
      final schemes = await SchemeApiService.fetchSchemesForUser();

      final flexiScheme = schemes.firstWhereOrNull(
        (scheme) => scheme.schemeType == 'flexi_plan',
      );

      if (flexiScheme == null || flexiScheme.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("no_flexi_plan".tr)),
        );
        return;
      }

      final int amountInPaise = (amount * 100).toInt();

      Get.to(
        () => FlexiPlanPaymentPage(
          amountInPaise: amountInPaise,
          grams: grams,
          schemeId: flexiScheme.id!,
        ),
        arguments: flexiScheme,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${"error".tr}: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final goldProvider = Provider.of<GoldRateProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('buy_gold'.tr)),
      body: SafeArea(
        child: goldProvider.error != null
            ? Center(child: Text("${"error".tr}: ${goldProvider.error}"))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    goldProvider.gold999Rate == null
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Column(
                            children: [
                              GoldPriceBanner(price: goldProvider.gold999Rate!),
                              const SizedBox(height: 16),
                              BuyInputSection(
                                goldRatePerGram: goldProvider.gold999Rate!,
                                onConfirm: _handleConfirm,
                              ),
                            ],
                          ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 20),
                    Text(
                      "explore_investment_schemes".tr,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const SchemeSection(),
                  ],
                ),
              ),
      ),
    );
  }
}
