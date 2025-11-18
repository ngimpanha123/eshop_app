import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/product_type_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/api_provider.dart';

class AdminProductController extends GetxController {
  final _api = Get.find<APIProvider>();
  final _picker = ImagePicker();

  // Observable lists
  var products = <ProductModel>[].obs;
  var productTypes = <ProductTypeModel>[].obs;
  var users = <UserModel>[].obs;

  // Loading states
  var isLoading = false.obs;
  var isSaving = false.obs;
  var isDeleting = false.obs;

  // Error and success messages
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalItems = 0.obs;

  // Form fields for Create/Edit
  var selectedImage = Rx<File?>(null);
  var selectedImageBase64 = ''.obs;
  var selectedProductType = Rxn<ProductTypeModel>();
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final priceController = TextEditingController();

  // Search and filter
  var searchQuery = ''.obs;
  var selectedFilterType = Rxn<ProductTypeModel>();

  @override
  void onInit() {
    super.onInit();
    fetchSetupData();
    fetchProducts();
  }

  @override
  void onClose() {
    nameController.dispose();
    codeController.dispose();
    priceController.dispose();
    super.onClose();
  }

  /// Fetch setup data (product types and users)
  Future<void> fetchSetupData() async {
    try {
      final res = await _api.getProductSetupData();
      
      if (res.statusCode == 200) {
        final data = res.data;
        
        productTypes.value = (data['productTypes'] as List)
            .map((type) => ProductTypeModel.fromJson(type))
            .toList();
        
        users.value = (data['users'] as List)
            .map((user) => UserModel.fromJson(user))
            .toList();
      }
    } catch (e) {
      print('❌ Setup Data Error: $e');
      errorMessage.value = 'Failed to load setup data: ${e.toString()}';
    }
  }

  /// Fetch products with optional pagination
  /// Set [enablePagination] to false to fetch all products without limits
  Future<void> fetchProducts({int page = 1, bool enablePagination = false}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Fetch all products without pagination limit
      final res = await _api.getProducts(
        page: enablePagination ? page : null,
        limit: enablePagination ? 10 : 1000, // Set to 1000 to get all products
      );

      if (res.statusCode == 200 && res.data['status'] == 'success') {
        final data = res.data['data'] as List;
        
        products.value = data
            .map((json) => ProductModel.fromJson(json))
            .toList();

        // Handle pagination if available
        if (res.data['pagination'] != null) {
          currentPage.value = res.data['pagination']['page'];
          totalPages.value = res.data['pagination']['totalPage'];
          totalItems.value = res.data['pagination']['total'];
        }
      } else {
        errorMessage.value = "Failed to load products (${res.statusCode})";
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print('❌ Fetch Products Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        
        // Convert to base64
        final bytes = await selectedImage.value!.readAsBytes();
        selectedImageBase64.value = 'data:image/png;base64,${base64Encode(bytes)}';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Take photo from camera
  Future<void> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        
        // Convert to base64
        final bytes = await selectedImage.value!.readAsBytes();
        selectedImageBase64.value = 'data:image/png;base64,${base64Encode(bytes)}';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Create a new product
  Future<void> createProduct() async {
    if (!_validateForm()) return;

    try {
      isSaving.value = true;
      errorMessage.value = '';

      final res = await _api.createProduct(
        name: nameController.text.trim(),
        code: codeController.text.trim(),
        unitPrice: priceController.text.trim(),
        typeId: selectedProductType.value!.id.toString(),
        imageBase64: selectedImageBase64.value.isNotEmpty 
            ? selectedImageBase64.value 
            : null,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        successMessage.value = res.data['message'] ?? 'Product created successfully';
        
        Get.snackbar(
          'Success',
          successMessage.value,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        clearForm();
        await fetchProducts();
        Get.back(); // Close the create dialog/screen
      } else {
        throw Exception(res.data['message'] ?? 'Failed to create product');
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Update an existing product
  Future<void> updateProduct(int productId) async {
    if (!_validateForm()) return;

    try {
      isSaving.value = true;
      errorMessage.value = '';

      final res = await _api.updateProduct(
        productId: productId,
        name: nameController.text.trim(),
        code: codeController.text.trim(),
        unitPrice: priceController.text.trim(),
        typeId: selectedProductType.value!.id.toString(),
        imageBase64: selectedImageBase64.value.isNotEmpty 
            ? selectedImageBase64.value 
            : null,
      );

      if (res.statusCode == 200) {
        successMessage.value = res.data['message'] ?? 'Product updated successfully';
        
        Get.snackbar(
          'Success',
          successMessage.value,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        clearForm();
        await fetchProducts();
        Get.back(); // Close the edit dialog/screen
      } else {
        throw Exception(res.data['message'] ?? 'Failed to update product');
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Delete a product
  Future<void> deleteProduct(int productId) async {
    try {
      isDeleting.value = true;

      final res = await _api.deleteProduct(productId: productId);

      if (res.statusCode == 200 || res.statusCode == 204) {
        Get.snackbar(
          'Success',
          'Product deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await fetchProducts();
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  /// Load product data into form for editing
  void loadProductForEdit(ProductModel product) {
    nameController.text = product.name;
    codeController.text = product.code;
    priceController.text = product.unitPrice.toString();
    selectedProductType.value = product.type;
    selectedImage.value = null;
    selectedImageBase64.value = '';
  }

  /// Validate form fields
  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter product name',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (codeController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter product code',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (priceController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter unit price',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (selectedProductType.value == null) {
      Get.snackbar('Error', 'Please select a product type',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }

  /// Clear form fields
  void clearForm() {
    nameController.clear();
    codeController.clear();
    priceController.clear();
    selectedProductType.value = null;
    selectedImage.value = null;
    selectedImageBase64.value = '';
  }

  /// Filter products by type
  List<ProductModel> get filteredProducts {
    if (selectedFilterType.value == null && searchQuery.value.isEmpty) {
      return products;
    }

    return products.where((product) {
      final matchesType = selectedFilterType.value == null ||
          product.type.id == selectedFilterType.value!.id;
      
      final matchesSearch = searchQuery.value.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          product.code.toLowerCase().contains(searchQuery.value.toLowerCase());

      return matchesType && matchesSearch;
    }).toList();
  }
}
