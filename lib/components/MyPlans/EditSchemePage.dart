import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/services/schemes_api_services.dart';
import '../../models/schemes_model.dart';
import '../../controller/schemes_controller.dart';

class EditSchemePage extends StatefulWidget {
  const EditSchemePage({super.key});

  @override
  State<EditSchemePage> createState() => _EditSchemePageState();
}

class _EditSchemePageState extends State<EditSchemePage> {
  final SchemeController controller = Get.find();
  final SchemeModel scheme = Get.arguments;

  int? selectedDuration;

  @override
  void initState() {
    super.initState();
    selectedDuration = scheme.duration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Scheme"),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Read-only: Scheme Type
            InputDecorator(
              decoration: const InputDecoration(
                labelText: "Scheme Type",
                border: OutlineInputBorder(),
              ),
              child: DropdownButton<String>(
                value: scheme.schemeType,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'fixed_plan', child: Text('Fixed Plan')),
                  DropdownMenuItem(value: 'flexi_plan', child: Text('Flexi Plan')),
                ],
                onChanged: null,
              ),
            ),
            const SizedBox(height: 16),

            /// Read-only: Metal
            InputDecorator(
              decoration: const InputDecoration(
                labelText: "Metal",
                border: OutlineInputBorder(),
              ),
              child: DropdownButton<String>(
                value: scheme.metal,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'gold', child: Text('Gold')),
                  DropdownMenuItem(value: 'silver', child: Text('Silver')),
                ],
                onChanged: null,
              ),
            ),
            const SizedBox(height: 16),

            /// Editable: Duration
            DropdownButtonFormField<int>(
              value: selectedDuration,
              items: const [
                DropdownMenuItem(value: 6, child: Text("6 months")),
                DropdownMenuItem(value: 12, child: Text("12 months")),
                DropdownMenuItem(value: 20, child: Text("20 months")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDuration = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Duration (Editable)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Read-only: Monthly Amount
            InputDecorator(
              decoration: const InputDecoration(
                labelText: "Monthly Amount",
                border: OutlineInputBorder(),
              ),
              child: DropdownButton<int>(
                value: scheme.monthlyAmount,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 2000, child: Text("₹2,000")),
                  DropdownMenuItem(value: 5000, child: Text("₹5,000")),
                  DropdownMenuItem(value: 10000, child: Text("₹10,000")),
                ],
                onChanged: null, // Make it read-only
              ),
            ),
            const SizedBox(height: 24),

            /// Update Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final updated = SchemeModel(
                    id: scheme.id,
                    schemeType: scheme.schemeType,
                    metal: scheme.metal,
                    duration: selectedDuration,
                    monthlyAmount: scheme.monthlyAmount,
                    oneTimeAmount: scheme.oneTimeAmount,
                  );

                  final success = await SchemeApiService.updateScheme(updated);
                  if (success) {
                    await controller.loadSchemesForUser(forceRefresh: true);
                    Get.back();
                    Get.snackbar("Success", "Scheme updated successfully");
                  } else {
                    Get.snackbar("Error", "Failed to update scheme");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Update Scheme"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
