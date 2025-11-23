import 'package:flutter/material.dart';
import 'package:gold_purchase_app/admin/admin_main_dashboard.dart';
import 'package:gold_purchase_app/components/MyPlans/EditSchemePage.dart';
import 'package:gold_purchase_app/payment/fixed_plan_payment.dart';
import '../views/auth/login_page.dart';
import '../views/auth/signup_page.dart';
import '../components/homepages/home_page.dart';
import '../views/auth/PinVerificationPage.dart';
import '../components/profilepages/kyc_verification/kyc_verification_page.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/login': (context) => LoginPage(),
    '/signup': (context) => SignupPage(),
    '/home': (context) => HomePage(),
    '/verify-pin': (context) => PinVerificationPage(),
    '/loginWithPin': (context) => PinVerificationPage(),
    '/kyc': (context) => KYCVerificationPage(),
    // '/EditProfilePage': (context) => const EditProfilePage(), // ✅ Add this line
    '/fixed_payment': (context) => const FixedPlanPaymentPage(), // ✅ Add this line
    // '/FlexiblePaymentPage': (context) => const FlexiblePaymentPage(), // ✅ Add this line
    '/edit_scheme' : (context) =>  EditSchemePage(),
    '/admin' : (context) =>  AdminMainDashboard()

 // ✅ Add this line
  };
}
