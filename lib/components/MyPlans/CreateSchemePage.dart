import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/schemes_controller.dart';
import '../../models/schemes_model.dart';

class CreateSchemeForm extends StatefulWidget {
  const CreateSchemeForm({super.key});

  @override
  State<CreateSchemeForm> createState() => _CreateSchemeFormState();
}

class _CreateSchemeFormState extends State<CreateSchemeForm>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<SchemeController>();
  final _formKey = GlobalKey<FormState>();

  final typeCtrl = TextEditingController();
  final metalCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final amountCtrl = TextEditingController();


final Map<String, String> schemeTypeLabels = {
  'fixed_plan': 'Fixed Plan',
  'flexi_plan': 'Flexible Plan',
};

final Map<String, String> durationLabels = {
  '3': '3 Months',
  '6': '6 Months',
  '10': '10 Months',
  '12': '12 Months',
};

final List<String> durations = ['3', '6', '10','12'];

final Map<String, String> amountLabels = {
  '2000': '₹2,000',
  '5000': '₹5,000',
  '10000': '₹10,000',
};


  bool isPressed = false;

  final goldColor = const Color(0xFFFFD700); // Gold
  final whiteColor = Colors.white;

  @override
  void initState() {
    super.initState();
    typeCtrl.text = 'fixed_plan';
    metalCtrl.text = 'gold';
    durationCtrl.text = '6';
    amountCtrl.text = '5000';
  }

  @override
  void dispose() {
    typeCtrl.dispose();
    metalCtrl.dispose();
    durationCtrl.dispose();
    amountCtrl.dispose();
    super.dispose();
  }

void _submitForm() {
  if (_formKey.currentState!.validate()) {
    final scheme = SchemeModel(
      id: null,
      schemeType: typeCtrl.text,
      metal: metalCtrl.text,
      duration: int.tryParse(durationCtrl.text), // ✅ always include duration
      monthlyAmount:
          typeCtrl.text == 'fixed_plan' ? int.tryParse(amountCtrl.text) : null,
      oneTimeAmount: null, // not required for now
    );

    controller.createScheme(scheme);
  }
}


@override
Widget build(BuildContext context) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 400),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 2,
        )
      ],
    ),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔶 Section: Header Title and Description
          const Text(
            '💡 Plan Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose your scheme type, duration, and amount to start saving in gold through our secure and flexible plans. Fixed plans require a monthly commitment.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 20),

          // 🔽 Your Existing Form Fields
  _buildDropdown(
  label: 'Scheme Type',
  value: typeCtrl.text,
  items: schemeTypeLabels.keys.toList(),
  labelMap: schemeTypeLabels,
  onChanged: (val) {
    setState(() {
      typeCtrl.text = val!;
      durationCtrl.text = '12';
      amountCtrl.text = typeCtrl.text == 'fixed_plan' ? '5000' : '';
    });
  },
),

          const SizedBox(height: 10),

          TextFormField(
            controller: metalCtrl..text = 'gold',
            readOnly: true,
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: _inputDecoration('Metal'),
          ),
          const SizedBox(height: 10),

      _buildDropdown(
  label: 'Duration (months)',
  value: durationCtrl.text,
  items: durations,
  labelMap: durationLabels,
  onChanged: (val) => setState(() => durationCtrl.text = val!),
),

          const SizedBox(height: 10),

          if (typeCtrl.text == 'fixed_plan')
            _buildDropdown(
  label: 'Monthly Amount',
  value: amountCtrl.text,
  items: amountLabels.keys.toList(),
  labelMap: amountLabels,
  onChanged: (val) => setState(() => amountCtrl.text = val!),
),

          const SizedBox(height: 20),

          Obx(() {
            return controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTapDown: (_) => setState(() => isPressed = true),
                    onTapUp: (_) => setState(() => isPressed = false),
                    onTapCancel: () => setState(() => isPressed = false),
                    onTap: _submitForm,
                    child: AnimatedScale(
                      scale: isPressed ? 0.95 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                        decoration: BoxDecoration(
                          color: goldColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: goldColor.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Join Scheme',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
          }),
        ],
      ),
    ),
  );
}


  // Styles

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: goldColor),
      filled: true,
      fillColor: Colors.grey.shade100,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: goldColor),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

Widget _buildDropdown({
  required String label,
  required String value,
  required List<String> items,
  required Function(String?) onChanged,
  Map<String, String>? labelMap,
}) {
  return DropdownButtonFormField<String>(
    value: value.isNotEmpty ? value : null,
    decoration: _inputDecoration(label),
    items: items.map((item) {
      return DropdownMenuItem(
        value: item, // backend value
        child: Text(labelMap?[item] ?? item), // user-friendly label
      );
    }).toList(),
    onChanged: onChanged,
    validator: (val) => val == null || val.isEmpty ? 'Select $label' : null,
  );
}

}
