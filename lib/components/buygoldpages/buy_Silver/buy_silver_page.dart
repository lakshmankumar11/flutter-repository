import 'package:flutter/material.dart';

class BuySilverPage extends StatefulWidget {
  final double currentPrice;
  final Function(double grams, double amount) onConfirm;

  const BuySilverPage({
    Key? key,
    required this.currentPrice,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<BuySilverPage> createState() => _BuySilverPageState();
}

class _BuySilverPageState extends State<BuySilverPage> {
  String _inputMode = 'Grams';
  double inputValue = 0;
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double totalAmount = _inputMode == 'Grams'
        ? inputValue * widget.currentPrice
        : inputValue;
    double grams = _inputMode == 'Amount'
        ? inputValue / widget.currentPrice
        : inputValue;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Silver Rate: ₹${widget.currentPrice.toStringAsFixed(2)} / g",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _inputMode,
              items: const [
                DropdownMenuItem(value: 'Grams', child: Text('Enter in Grams')),
                DropdownMenuItem(value: 'Amount', child: Text('Enter in ₹ Amount')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _inputMode = value;
                    inputValue = 0;
                    _inputController.clear();
                  });
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Select Input Mode",
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: _inputMode == 'Grams' ? "Enter grams" : "Enter amount",
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter a value";
                }
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0) {
                  return "Enter a valid number greater than 0";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  inputValue = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _inputMode == 'Grams'
                    ? "Total: ₹${totalAmount.toStringAsFixed(2)}"
                    : "You will receive: ${grams.toStringAsFixed(2)} g",
                key: ValueKey(_inputMode + inputValue.toString()),
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
            const SizedBox(height: 24),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC0C0C0), Color(0xFFE0E0E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: MaterialButton(
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onConfirm(grams, totalAmount);
                  }
                },
                child: const Text(
                  "Confirm & Pay",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
