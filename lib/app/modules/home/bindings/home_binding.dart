import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../product/controllers/product_controller.dart';
import '../../cart/controllers/cart_controller.dart';
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
    
    // Pre-initialize all nested tab controllers with permanent flag
    // This prevents them from being deleted when switching tabs
    Get.put(ProductController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(SearchProductController(), permanent: true);
    Get.put(AppSettingsController(), permanent: true);
  }
}
