import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gold_purchase_app/components/MyPlans/MyPlansPage.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../views/config/constantsApiBaseUrl.dart';
import '../controller/user_details_controller.dart';
import '../controller/OrderController.dart';

class RazorpayPage extends StatefulWidget {
  final int amountInPaise;
  final String schemeId;
  final String? paymentDate;

  const RazorpayPage({
    super.key,
    required this.amountInPaise,
    required this.schemeId,
    this.paymentDate,
  });

  @override
  State<RazorpayPage> createState() => _RazorpayPageState();
}

final UserDetailsController userDetailsController =
    Get.find<UserDetailsController>();
final OrderController orderController = Get.find<OrderController>();

class _RazorpayPageState extends State<RazorpayPage>
    with SingleTickerProviderStateMixin {
  late Razorpay _razorpay;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String? userName;
  String mobile = '';
  String? token;
  String? userId;
  bool _isLoading = false;
  bool _userReady = false;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
    _initialize();
  }

  Future<void> _initialize() async {
    await loadUserDetails();
    setState(() => _userReady = true);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    userId = prefs.getString('user_id');
    userName = prefs.getString('username');

    if (token != null) {
      final decodedToken = JwtDecoder.decode(token!);
      mobile = decodedToken['mobile']?.toString() ?? '';
    }
  }

  Future<void> createOrderAndPay() async {
    if (_isLoading || !_userReady) return;
    setState(() => _isLoading = true);

    try {
      if (token == null || userId == null || userId!.isEmpty) {
        showSnack(
          "⚠️ Please log in to continue with your payment.",
          background: Colors.orange,
        );
        return;
      }

      final url = Uri.parse("${AppConstants.baseUrl}/order/create");
      final body = {
        'userId': userId,
        'schemeId': widget.schemeId,
        'amount': (widget.amountInPaise / 100).toInt(),
        if (widget.paymentDate != null) 'paymentDate': widget.paymentDate,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final orderId = data['order']?['id']?.toString() ?? '';

        if (orderId.isEmpty) {
          showSnack("❌ Order ID not received. Please retry.");
          return;
        }

        _startPayment(orderId);
      } else {
        final message =
            jsonDecode(response.body)['message'] ??
            "Unable to create your payment order. Try again.";
        showSnack("❌ $message");
      }
    } catch (e) {
      showSnack("❌ Something went wrong. Please try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _startPayment(String orderId) {
    final options = {
      'key': 'rzp_test_D2huYxwxY9jGTv',
      'amount': widget.amountInPaise,
      'name': userName ?? 'User',
      'description': 'Gold Scheme Purchase',
      'order_id': orderId,
      'prefill': {'contact': mobile},
      'theme': {'color': '#FFC107'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      showSnack("⚠️ Failed to start Razorpay. Please try again.");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/animations/Payment.json',
                    height: 200,
                    repeat: false,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Payment ID: ${response.paymentId}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[600],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MyPlansPage()),
                        );
                      });
                    },
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Payment Success: ${response.paymentId}"),
        backgroundColor: Colors.green,
      ),
    );

    orderAfterPayment(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showSnack("❌ Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showSnack(
      "💰 External Wallet: ${response.walletName}",
      background: Colors.blue,
    );
  }

  Future<void> orderAfterPayment(PaymentSuccessResponse response) async {
    final url = Uri.parse("${AppConstants.baseUrl}/order/verify");
    final double amountPaid = widget.amountInPaise / 100;
    final double gramWeight = amountPaid / 600;

    final body = {
      "razorpay_payment_id": response.paymentId,
      "razorpay_order_id": response.orderId,
      "razorpay_signature": response.signature,
      "userId": userId,
      "schemeId": widget.schemeId,
      "amount": amountPaid,
      "amountPaid": amountPaid,
      "gramWeight": gramWeight,
      if (widget.paymentDate != null) "paymentDate": widget.paymentDate,
    };

    try {
      final res = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        showSnack("✅ Payment verified and saved.", background: Colors.green);

        await Future.wait([
          orderController.fetchOrders(),
          userDetailsController.loadUserDetails(),
        ]);
        Navigator.pop(context);
      } else {
        final errorData = jsonDecode(res.body);
        final message = errorData['message'] ?? "Payment verification failed.";

        showSnack("❌ $message");
      }
    } catch (e) {
      showSnack("❌ Something went wrong. Please try again.");
    }
  }

  void showSnack(
    String msg, {
    Color? background = Colors.red,
    int durationSeconds = 3,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: background,
        duration: Duration(seconds: durationSeconds),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount = (widget.amountInPaise / 100).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suba Gold"),
        backgroundColor: Colors.amber[600],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    size: 40,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Pay ₹$amount",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  (_isLoading || !_userReady)
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[600],
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                            shadowColor: Colors.amber,
                          ),
                          onPressed: createOrderAndPay,
                          icon: const Icon(Icons.payment),
                          label: const Text(
                            "Pay Now",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
