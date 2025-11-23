import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import 'package:get/get.dart';

class TransactionCard extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;

    final formattedDate =
        DateFormat('MMM dd, yyyy').format(transaction.date.toLocal());
    final bool isGold = transaction.metal.toLowerCase() == 'gold';

    final Color cardColor =
        isGold ? const Color.fromARGB(255, 236, 181, 4) : Colors.grey.shade600;
    final List<Color> gradientColors = isGold
        ? [const Color.fromARGB(255, 245, 234, 179), const Color(0xFFFFF8DC)]
        : [Colors.grey.shade300, Colors.white];

    final friendlyScheme = getFriendlySchemeType(transaction.scheme);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: cardColor,
                child: const Icon(Icons.trending_up_rounded,
                    color: Colors.white, size: 28),
              ),
              title: Text(
                '${'buy_text'.tr} ($friendlyScheme)',
                style: TextStyle(
                  color: cardColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                      '${'grams'.tr}: ${transaction.gramsPurchased.toStringAsFixed(3)} g',
                      style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  Text('${'metal'.tr}: ${capitalizeWord(transaction.metal)}',
                      style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  if (transaction.scheme != 'flexi_plan')
                    Text(
                        '${'payment_month'.tr}: ${formatMonthYear(transaction.paymentMonth)}',
                        style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  Text('${'date'.tr}: $formattedDate',
                      style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
              trailing: IconButton(
                icon: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: _expanded ? 0.5 : 0,
                  child: const Icon(Icons.expand_more),
                ),
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Colors.grey.shade400),
                    Text(
                        '${'amount_paid'.tr}: ₹${transaction.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                    const SizedBox(height: 4),
                    Text('${'transaction_id'.tr}: ${transaction.id}',
                        style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              crossFadeState:
                  _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            )
          ],
        ),
      ),
    );
  }

  String getFriendlySchemeType(String schemeType) {
    const schemeMap = {
      'flexi_plan': 'flexible_plan_trans',
      'daily_plan': 'daily_plan_trans',
      'fixed_plan': 'fixed_plan_trans',
      'weekly_plan': 'weekly_plan_trans',
    };
    final key = schemeMap[schemeType] ?? schemeType.replaceAll('_', ' ');
    return key.tr;
  }

  String capitalizeWord(String input) {
    return input.isNotEmpty
        ? input[0].toUpperCase() + input.substring(1).toLowerCase()
        : input;
  }

  String formatMonthYear(String monthString) {
    try {
      final parts = monthString.split('-');
      if (parts.length == 2) {
        final month = int.parse(parts[0]);
        final year = int.parse(parts[1]);
        final date = DateTime(year, month);
        return DateFormat('MMMM yyyy').format(date);
      }
      return monthString;
    } catch (_) {
      return monthString;
    }
  }
}
