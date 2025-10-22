import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../../../data/providers/api_provider.dart';

class ProductBinding extends Bindings {
  @override
  // void dependencies() {
  //   Get.lazyPut<ProductController>(
  //     () => ProductController(),
  //   );
  // }
  void dependencies() {
    Get.lazyPut(() => APIProvider());
    Get.lazyPut(() => ProductController());
  }
}
