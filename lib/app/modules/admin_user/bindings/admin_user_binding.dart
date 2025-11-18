import 'package:get/get.dart';
import '../controllers/admin_user_controller.dart';

class AdminUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUserController>(
      () => AdminUserController(),
    );
  }
}
