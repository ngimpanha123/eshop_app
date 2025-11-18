import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pos/app/modules/dashboard/views/dashboard_view.dart';

import '../../../routes/app_pages.dart';
import '../../app_settings/views/app_settings_view.dart';
import '../../admin_product/views/admin_product_list_view.dart';
import '../../admin_sales/views/admin_sales_view.dart';
import '../../cashier_order/views/cashier_order_view.dart';
import '../../cashier_sales/views/cashier_sales_view.dart';
import '../../product/views/product_view.dart';
import '../../profile/views/profile_view.dart';
import '../../reports/views/reports_view.dart';
import '../../search_product/views/search_product_view.dart';
import '../../user/views/user_view.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  
  // Main bottom navigation routes
  var lstRoutesName = [
    Routes.DASHBOARD,
    Routes.PRODUCT,
    Routes.CASHIER_SALES,
    Routes.REPORTS,
    Routes.PROFILE,
  ];

  void onPageChange(index) {
    selectedIndex.value = index;
    Get.offAllNamed(lstRoutesName[index], id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    // Main Routes
    if (settings.name == Routes.DASHBOARD) {
      return GetPageRoute(
        settings: settings,
        page: () => const DashboardView(),
      );
    }

    if (settings.name == Routes.CASHIER_ORDER) {
      return GetPageRoute(
        settings: settings,
        page: () => const CashierOrderView(),
      );
    }

    if (settings.name == Routes.CASHIER_SALES) {
      return GetPageRoute(
        settings: settings,
        page: () => const CashierSalesView(),
      );
    }

    if (settings.name == Routes.REPORTS) {
      return GetPageRoute(
        settings: settings,
        page: () => const ReportsView(),
      );
    }

    if (settings.name == Routes.PROFILE) {
      return GetPageRoute(
        settings: settings,
        page: () => const ProfileView(),
      );
    }

    // Additional Routes (accessible from menu/drawer)
    if (settings.name == Routes.PRODUCT) {
      return GetPageRoute(settings: settings, page: () => const ProductView());
    }

    if (settings.name == Routes.SEARCH_PRODUCT) {
      return GetPageRoute(
        settings: settings,
        page: () => const SearchProductView(),
      );
    }

    if (settings.name == Routes.ADMIN_PRODUCT) {
      return GetPageRoute(
        settings: settings,
        page: () => const AdminProductListView(),
      );
    }

    if (settings.name == Routes.ADMIN_SALES) {
      return GetPageRoute(
        settings: settings,
        page: () => const AdminSalesView(),
      );
    }

    if (settings.name == Routes.APP_SETTINGS) {
      return GetPageRoute(
        settings: settings,
        page: () => const AppSettingsView(),
      );
    }

    if (settings.name == Routes.USER) {
      return GetPageRoute(
        settings: settings,
        page: () => const UserView(),
      );
    }

    return null;
  }
}
