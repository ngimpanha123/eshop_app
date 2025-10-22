import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';

class ProductController extends GetxController {
  final _api = Get.find<APIProvider>();

  var products = [].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs; // ✅ Added this

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; // reset error
      final res = await _api.getProducts();

      if (res.statusCode == 200 && res.data['status'] == 'success') {
        products.value = res.data['data'];
      } else {
        errorMessage.value = "Failed to load products (${res.statusCode})";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
