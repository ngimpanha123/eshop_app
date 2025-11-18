import 'package:get/get.dart';
import '../controllers/cashier_order_controller.dart';

class CashierOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CashierOrderController>(
      () => CashierOrderController(),
    );
  }
}
