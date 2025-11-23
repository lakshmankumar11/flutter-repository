import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gold_purchase_app/admin/adminApis/controllers/user_list_profile_controller.dart';
import 'package:gold_purchase_app/admin/adminApis/controllers/user_scheme_controller.dart';
import 'package:gold_purchase_app/admin/admin_main_dashboard.dart';
import 'package:gold_purchase_app/components/homepages/home_page.dart';
import 'package:gold_purchase_app/controller/user_details_controller.dart';
import 'package:provider/provider.dart';
import 'providers/metal_rate_provider.dart';
import 'routes/app_routes.dart';
import './IntroPage/IntroPage.dart';
import './providers/user_profile_provider.dart';
import 'package:get/get.dart';
import 'controller/UserController.dart';
import 'controller/OrderController.dart';
import './controller/schemes_controller.dart';
import 'language/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ✅ Font size controller (added)
class FontSizeController extends GetxController {
  RxDouble fontSize = 16.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    fontSize.value = prefs.getDouble('fontSize') ?? 16.0;
  }

  Future<void> _saveFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', fontSize.value);
  }

  void increaseFont() {
    if (fontSize.value < 30) {
      fontSize.value += 2;
      _saveFontSize();
    }
  }

  void decreaseFont() {
    if (fontSize.value > 10) {
      fontSize.value -= 2;
      _saveFontSize();
    }
  }

  void resetFont() {
    fontSize.value = 16.0;
    _saveFontSize();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env before runApp
  await dotenv.load(fileName: "assets/.env");

  // Register controllers with GetX
  Get.put(UserController());
  Get.put(AdminUserController());
  Get.put(UserDetailsController());
  Get.put(OrderController());
  Get.put(SchemeController(), permanent: true);
  Get.put(UserSchemeController());
  Get.put(FontSizeController(), permanent: true); // ✅ Font size controller

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoldRateProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final fontController = Get.find<FontSizeController>();

    return Obx(() => GetMaterialApp(
          title: 'Suba Gold Jewellery App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.amber,
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: fontController.fontSize.value),
              bodyMedium: TextStyle(fontSize: fontController.fontSize.value - 2),
              titleLarge: TextStyle(fontSize: fontController.fontSize.value + 2),
            ),
          ),
          translations: AppTranslations(),
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          home: const IntroPage(),
          routes: AppRoutes.routes,
        ));
  }
}
