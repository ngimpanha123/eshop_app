import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pos/app/modules/dashboard/views/dashboard_view.dart';

import '../../../routes/app_pages.dart';
import '../../app_settings/views/app_settings_view.dart';
import '../../cart/views/cart_view.dart';
import '../../product/views/product_view.dart';
import '../../search_product/views/search_product_view.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var selectedIndex = 0.obs;
  var lstRoutesName = [
    Routes.PRODUCT,
    Routes.DASHBOARD,
    Routes.SEARCH_PRODUCT,
    Routes.CART,
    Routes.APP_SETTINGS,
  ];
  void onPageChange(index) {
    selectedIndex.value = index;
    Get.offAllNamed(lstRoutesName[index], id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    // Controllers are pre-initialized in HomeBinding, so no bindings needed here
    if (settings.name == Routes.PRODUCT) {
      return GetPageRoute(settings: settings, page: () => const ProductView());
    }

    if (settings.name == Routes.DASHBOARD) {
      return GetPageRoute(
        settings: settings,
        page: () => const DashboardView(),
      );
    }

    if (settings.name == Routes.SEARCH_PRODUCT) {
      return GetPageRoute(
        settings: settings,
        page: () => const SearchProductView(),
      );
    }

    if (settings.name == Routes.CART) {
      return GetPageRoute(settings: settings, page: () => const CartView());
    }

    if (settings.name == Routes.APP_SETTINGS) {
      return GetPageRoute(
        settings: settings,
        page: () => const AppSettingsView(),
      );
    }

    return null;
  }
}
