import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvKeys {
  static String get razorpayKey => dotenv.env['RAZORPAY_KEY_ID'] ?? '';
}
