import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/product_type_model.dart';

class ProductController extends GetxController with GetSingleTickerProviderStateMixin {
  final _api = Get.find<APIProvider>();

  // Observable lists
  var allProducts = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var productTypes = <ProductTypeModel>[].obs;
  
  // UI state
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedTabIndex = 0.obs;
  var selectedTypeId = Rx<int?>(null);
  
  // Tab controller
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
      if (tabController.index == 0) {
        // Reset filter when switching to "All" tab
        filterByType(null);
      }
    });
    
    fetchProductTypes();
    fetchProducts();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Fetch all products
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final res = await _api.getProducts(limit: 1000);

      if (res.statusCode == 200 && res.data['status'] == 'success') {
        final List<dynamic> data = res.data['data'];
        allProducts.value = data.map((json) => ProductModel.fromJson(json)).toList();
        filteredProducts.value = allProducts;
      } else {
        errorMessage.value = "Failed to load products (${res.statusCode})";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all product types
  Future<void> fetchProductTypes() async {
    try {
      final res = await _api.getProductTypes();

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data'];
        productTypes.value = data.map((json) => ProductTypeModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('❌ Error fetching product types: $e');
    }
  }

  /// Filter products by type
  void filterByType(int? typeId) {
    selectedTypeId.value = typeId;
    
    if (typeId == null) {
      filteredProducts.value = allProducts;
    } else {
      filteredProducts.value = allProducts.where((product) => product.type.id == typeId).toList();
    }
  }

  /// Search products
  void searchProducts(String query) {
    if (query.isEmpty) {
      if (selectedTypeId.value == null) {
        filteredProducts.value = allProducts;
      } else {
        filterByType(selectedTypeId.value);
      }
      return;
    }

    final searchQuery = query.toLowerCase();
    var results = allProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery) ||
             product.code.toLowerCase().contains(searchQuery);
    }).toList();

    if (selectedTypeId.value != null) {
      results = results.where((product) => product.type.id == selectedTypeId.value).toList();
    }

    filteredProducts.value = results;
  }

  /// Delete product
  Future<bool> deleteProduct(int productId) async {
    try {
      final res = await _api.deleteProduct(productId: productId);
      
      if (res.statusCode == 200) {
        await fetchProducts();
        Get.snackbar(
          'Success',
          'Product deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete product',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Delete product type
  Future<bool> deleteProductType(int typeId) async {
    try {
      final res = await _api.deleteProductType(typeId: typeId);
      
      if (res.statusCode == 200) {
        await fetchProductTypes();
        await fetchProducts();
        Get.snackbar(
          'Success',
          'Product type deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete product type',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      fetchProducts(),
      fetchProductTypes(),
    ]);
  }
}
