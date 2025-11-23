import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../../../models/schemes_model.dart';
import '../../../providers/metal_rate_provider.dart';
import '../../../payment/razorpay_payment.dart';
import '../controller/user_details_controller.dart';
import '../controller/OrderController.dart';
import '../models/transaction_model.dart';

class FixedPlanPaymentPage extends StatefulWidget {
  const FixedPlanPaymentPage({super.key});

  @override
  State<FixedPlanPaymentPage> createState() => _FixedPlanPaymentPageState();
}

class _FixedPlanPaymentPageState extends State<FixedPlanPaymentPage> {
  bool _loading = false;
  Map<DateTime, bool> _monthlyStatus = {};
  DateTime? _selectedDate;

  @override
  void initState() {
    Get.put(OrderController());
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGoldRate();
      _initCalendarData();
    });
  }

  void _initCalendarData() async {
    final orderController = Get.find<OrderController>();
    await orderController.fetchOrders();
    final List<TransactionModel> transactions = orderController.transactions;
    final Map<DateTime, bool> paidMap = {};
    for (final tx in transactions) {
      final dt = tx.date;
      final key = DateTime(dt.year, dt.month, dt.day);
      paidMap[key] = true;
    }
    setState(() {
      _monthlyStatus = paidMap;
    });
  }

  Future<void> _loadGoldRate() async {
    setState(() => _loading = true);
    await Provider.of<GoldRateProvider>(context, listen: false).fetchMetalPrices();
    if (mounted) setState(() => _loading = false);
  }

  String _monthLabel(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return "${_monthText(dt.month)} ${dt.year}";
    } catch (_) {
      return "invalid".tr;
    }
  }

  String _monthText(int m) {
    const names = [
      '',
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[m].tr;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final SchemeModel scheme = Get.arguments;
    final goldRate = Provider.of<GoldRateProvider>(context).gold999Rate ?? 0.0;
    final controller = Get.find<UserDetailsController>();
    final user = controller.userDetails.value;

    double totalPaid = 0.0;
    String lastPaid = "no_payments_yet".tr;

    if (user != null) {
      totalPaid = user.overallSummary.totalAmountPaid;
      if (user.monthlySummary.isNotEmpty && user.monthlySummary.last.payments.isNotEmpty) {
        lastPaid = _monthLabel(user.monthlySummary.last.payments.last.paymentDate);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('fixed_plan_payment'.tr, style: const TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFFFD700),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFFDFDFD),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Scheme Details ──
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('scheme_details'.tr,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          _infoRow("type", scheme.schemeType),
                          _infoRow("metal", scheme.metal),
                          _infoRow("duration", "${scheme.duration} ${'months'.tr}"),
                          if (scheme.monthlyAmount != null)
                            _infoRow("monthly", "₹${scheme.monthlyAmount}"),
                          if (scheme.oneTimeAmount != null)
                            _infoRow("one_time", "₹${scheme.oneTimeAmount}"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // ── Calendar ──
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text('select_date_to_pay'.tr,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            TableCalendar(
                              firstDay: DateTime.now().subtract(const Duration(days: 60)),
                              lastDay: DateTime.now().add(const Duration(days: 60)),
                              focusedDay: _selectedDate ?? DateTime.now(),
                              calendarFormat: CalendarFormat.month,
                              selectedDayPredicate: (day) =>
                                  _selectedDate != null && isSameDay(day, _selectedDate),
                              onDaySelected: (selectedDay, _) {
                                final now = DateTime.now();
                                final selectedMonth = DateTime(selectedDay.year, selectedDay.month);
                                final currentMonth = DateTime(now.year, now.month);
                                final nextMonth = DateTime(now.year, now.month + 1);
                                if (selectedMonth == currentMonth || selectedMonth == nextMonth) {
                                  setState(() => _selectedDate = selectedDay);
                                } else {
                                  Get.snackbar("invalid".tr, "only_current_or_next_month_allowed".tr,
                                      backgroundColor: Colors.red.shade100,
                                      colorText: Colors.black);
                                }
                              },
                              headerStyle: HeaderStyle(
                                titleCentered: true,
                                formatButtonVisible: false,
                                titleTextStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                leftChevronIcon:
                                    const Icon(Icons.arrow_back_ios, size: 18),
                                rightChevronIcon:
                                    const Icon(Icons.arrow_forward_ios, size: 18),
                              ),
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.deepOrange, width: 2),
                                  color: const Color.fromARGB(255, 10, 10, 10),
                                ),
                                selectedDecoration: const BoxDecoration(
                                  color: Color(0xFF1E88E5),
                                  shape: BoxShape.circle,
                                ),
                                selectedTextStyle:
                                    const TextStyle(color: Colors.white),
                                defaultTextStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, date, _) {
                                  final normalizedDate =
                                      DateTime(date.year, date.month, date.day);
                                  final isPaid =
                                      _monthlyStatus[normalizedDate] ?? false;
                                  final isSelected = _selectedDate != null &&
                                      isSameDay(date, _selectedDate);
                                  final isToday =
                                      isSameDay(date, DateTime.now());

                                  Color bgColor;
                                  if (isSelected) {
                                    bgColor = const Color(0xFF1E88E5);
                                  } else if (isPaid) {
                                    bgColor = const Color(0xFF4CAF50);
                                  } else if (isToday) {
                                    bgColor = Colors.orange.shade300;
                                  } else {
                                    bgColor = const Color(0xFFE0E0E0);
                                  }

                                  final dayText = Text('${date.day}',
                                      style:
                                          const TextStyle(color: Colors.white));
                                  final decoratedDay = Container(
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: bgColor, shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: dayText,
                                  );

                                  if (isPaid) {
                                    return Tooltip(
                                      message:
                                          '${'you_paid_on'.tr} ${DateFormat('dd MMM yyyy').format(date)}',
                                      child: decoratedDay,
                                      waitDuration:
                                          const Duration(milliseconds: 300),
                                      showDuration: const Duration(seconds: 2),
                                    );
                                  }

                                  return decoratedDay;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _LegendItem(color: const Color(0xFF4CAF50), label: "paid_date".tr),
                                _LegendItem(color: const Color(0xFF1E88E5), label: "selected".tr),
                                _LegendItem(
                                    color: const Color.fromARGB(255, 16, 16, 16),
                                    label: "current_date".tr),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // ── Monthly Amount Card ──
                  if (scheme.monthlyAmount != null)
                    FadeInUp(
                      duration: const Duration(milliseconds: 650),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("monthly_payment".tr,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("₹${scheme.monthlyAmount}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),

                  // ── Payment Button ──
                  FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_selectedDate == null) {
                            Get.snackbar("select_date".tr,
                                "please_select_date_to_proceed".tr,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.black);
                            return;
                          }

                          final formattedDate = _formatDate(_selectedDate!);
                          if (scheme.monthlyAmount != null) {
                            final amountInPaise =
                                (scheme.monthlyAmount! * 100).toInt();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RazorpayPage(
                                  amountInPaise: amountInPaise,
                                  schemeId: scheme.id ?? '',
                                  paymentDate: formattedDate,
                                ),
                              ),
                            );
                          } else {
                            Get.snackbar("error".tr, "monthly_amount_not_available".tr,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.black);
                          }
                        },
                        icon: const Icon(Icons.payment, color: Colors.black),
                        label:
                            Text('pay_now'.tr, style: const TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
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

// ── Legend UI ──
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
