import 'package:get/get.dart';
import '../controllers/cashier_sales_controller.dart';

class CashierSalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CashierSalesController>(
      () => CashierSalesController(),
    );
  }
}
