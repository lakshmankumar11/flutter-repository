import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gold_purchase_app/components/buygoldpages/buy_gold_page.dart';
import 'package:gold_purchase_app/controller/schemes_controller.dart';

class SchemesPage extends StatelessWidget {
  const SchemesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SchemeController());
    controller.loadSchemesForUser(); // Load once

    return Scaffold(
      body: const SchemesListWidget(),
    );
  }
}

class SchemesListWidget extends StatelessWidget {
  const SchemesListWidget({super.key});

  String getFriendlySchemeType(String schemeType) {
    const schemeTypeMap = {
      'flexi_plan': 'scheme_type_flexi',
      'fixed_plan': 'scheme_type_fixed',
    };
    return schemeTypeMap[schemeType]?.tr ??
        schemeType.replaceAll('_', ' ').capitalizeFirst!;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SchemeController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final schemes = controller.schemes;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (schemes.isEmpty)
              Center(child: Text("no_schemes_found".tr)),
            ...schemes.asMap().entries.map((entry) {
              final index = entry.key;
              final scheme = entry.value;

              return FadeInUp(
                duration: Duration(milliseconds: 300 + (index * 100)),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFE135)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'scheme_details'.tr,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 8),
                        _buildRow("scheme_type".tr, getFriendlySchemeType(scheme.schemeType)),
                        _buildRow("metal".tr, scheme.metal),
                        _buildRow("duration".tr, "${scheme.duration} ${'months'.tr}"),
                        if (scheme.monthlyAmount != null)
                          _buildRow("monthly".tr, "₹${scheme.monthlyAmount}"),
                        if (scheme.oneTimeAmount != null)
                          _buildRow("one_time".tr, "₹${scheme.oneTimeAmount}"),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                final controller = Get.find<SchemeController>();

                                if (scheme.schemeType == 'fixed_plan') {
                                  Get.toNamed('/fixed_payment', arguments: scheme);
                                } else if (scheme.schemeType == 'flexi_plan') {
                                  controller.selectedScheme.value = scheme;
                                  Get.to(() => const BuyGoldPage());
                                } else {
                                  Get.snackbar("invalid_scheme".tr, "unknown_scheme_type".tr);
                                }
                              },
                              icon: const Icon(Icons.payment, color: Colors.black),
                              label: Text(
                                'pay_plan'.tr,
                                style: const TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
