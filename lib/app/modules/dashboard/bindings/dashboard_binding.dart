import 'package:get/get.dart';
import '../../../services/dashboard_service.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardService>(() => DashboardService());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
