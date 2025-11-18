import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../product/controllers/product_controller.dart';
import '../../admin_product/controllers/admin_product_controller.dart';
import '../../admin_sales/controllers/admin_sales_controller.dart';
import '../../cashier_order/controllers/cashier_order_controller.dart';
import '../../cashier_sales/controllers/cashier_sales_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../reports/controllers/reports_controller.dart';
import '../../search_product/controllers/search_product_controller.dart';
import '../../app_settings/controllers/app_settings_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../data/providers/api_provider.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize HomeController
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    
    // Initialize APIProvider (shared across all controllers)
    if (!Get.isRegistered<APIProvider>()) {
      Get.put(APIProvider(), permanent: true);
    }
    
    // Pre-initialize all main bottom navigation controllers with permanent flag
    // This prevents them from being deleted when switching tabs
    Get.put(DashboardController(), permanent: true);
    Get.put(CashierOrderController(), permanent: true);
    Get.put(CashierSalesController(), permanent: true);
    Get.put(ReportsController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    
    // Pre-initialize additional controllers (accessible from menu/drawer)
    Get.put(ProductController(), permanent: true);
    Get.put(AdminProductController(), permanent: true);
    Get.put(AdminSalesController(), permanent: true);
    Get.put(SearchProductController(), permanent: true);
    Get.put(AppSettingsController(), permanent: true);
  }
}
