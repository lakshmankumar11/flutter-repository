import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gold_purchase_app/controller/schemes_controller.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart'; // ✅ For firstWhereOrNull

class BuyInputSection extends StatefulWidget {
  final double goldRatePerGram; // Fixed rate per gram
  final void Function(double goldInGrams, double amount) onConfirm;

  const BuyInputSection({
    Key? key,
    required this.goldRatePerGram,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<BuyInputSection> createState() => _BuyInputSectionState();
}

class _BuyInputSectionState extends State<BuyInputSection> {
  final TextEditingController _inputController = TextEditingController();
  String _inputMode = 'Amount'; // 'Amount' or 'Grams'
  bool _isCalculating = false;
  bool _isInputValid = true;

  double _grams = 0;
  double _amount = 0;

  final schemeController = Get.put(SchemeController());

  void _onInputChanged(String value) {
    final input = double.tryParse(value) ?? 0;

    setState(() {
      if (_inputMode == 'Amount') {
        _amount = input;
        _grams = input / widget.goldRatePerGram;
        _isInputValid = input <= 100000; // ✅ Max ₹10,0000
      } else {
        _grams = input;
        _amount = input * widget.goldRatePerGram;
        _isInputValid = _amount <= 100000; // ✅ Check equivalent amount
      }
    });
  }

  Future<void> _confirmPurchase() async {
    setState(() => _isCalculating = true);

    try {
      await schemeController.loadSchemesForUser();

      final scheme = schemeController.schemes.firstWhereOrNull(
        (s) => s.schemeType == 'flexi_plan',
      );

      if (scheme == null || scheme.id == null) {
        setState(() => _isCalculating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No Flexi Plan found for this user."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_grams <= 0 || _amount <= 0) {
        setState(() => _isCalculating = false);
        return;
      }

      // Optional delay for UX
      await Future.delayed(const Duration(seconds: 3));

      widget.onConfirm(_grams, _amount);

      setState(() => _isCalculating = false);
    } catch (e) {
      setState(() => _isCalculating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Gold Rate: ₹${widget.goldRatePerGram.toStringAsFixed(2)}/g",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Text("Change to: ", style: TextStyle(fontSize: 15)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _inputMode,
                    items: const [
                      DropdownMenuItem(value: 'Amount', child: Text("Amount (₹)")),
                      DropdownMenuItem(value: 'Grams', child: Text("Grams (g)")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _inputMode = value!;
                        _inputController.clear();
                        _grams = 0;
                        _amount = 0;
                        _isInputValid = true;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _inputController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: _onInputChanged,
                decoration: InputDecoration(
                  prefixIcon: Icon(_inputMode == 'Amount' ? Icons.currency_rupee : Icons.scale),
                  hintText: _inputMode == 'Amount' ? "Enter amount in ₹" : "Enter grams",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _isInputValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _isInputValid ? Colors.blue : Colors.red,
                      width: 2,
                    ),
                  ),
                  errorText: _isInputValid ? null : "Maximum limit is ₹1,00000",
                ),
              ),

              const SizedBox(height: 16),
              Text(
                _inputMode == 'Amount'
                    ? "You will receive: ${_grams.toStringAsFixed(2)} g"
                    : "You need to pay: ₹${_amount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 30),

              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade700, Colors.orange.shade400],
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: (_isCalculating || !_isInputValid || _amount <= 0)
                        ? null
                        : _confirmPurchase,
                    child: _isCalculating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Confirm Purchase", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.3, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
