import 'package:flutter/material.dart';

class GoldPriceBanner extends StatelessWidget {
  final double price;

  const GoldPriceBanner({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: Colors.orange, size: 28),
          const SizedBox(width: 10),
          Expanded( // ✅ Makes text responsive
            child: Text(
              'Current Gold Price: ₹${price.toStringAsFixed(2)} / gram',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis, // ✅ Prevents overflow
            ),
          ),
        ],
      ),
    );
  }
}
