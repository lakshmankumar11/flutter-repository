// utils/refresh_helpers.dart
import 'package:flutter/material.dart';
import 'package:gold_purchase_app/admin/adminApis/controllers/user_list_profile_controller.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../providers/metal_rate_provider.dart';
import '../providers/user_profile_provider.dart';
import '../controller/user_details_controller.dart';
import '../controller/OrderController.dart';
import '../controller/schemes_controller.dart';

Future<void> handleGlobalRefresh(BuildContext context, {bool refreshOrders = false}) async {
  try {
    // GetX Controllers
    await Get.find<UserDetailsController>().loadUserDetails();
    await Get.find<SchemeController>().loadSchemesForUser(forceRefresh: true);
    await Get.find<AdminUserController>().loadUsers(forceRefresh: true);


    if (refreshOrders) {
      await Get.find<OrderController>().fetchOrders();
    }

    // Provider-based (requires context)
    await context.read<GoldRateProvider>().fetchMetalPrices(silent: false);
    await context.read<UserProfileProvider>().fetchUserProfile();

    // No setState here – let the widget call setState if needed
  } catch (e) {

  }
}
