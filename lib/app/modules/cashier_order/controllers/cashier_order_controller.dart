import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';
import '../../../data/providers/api_provider.dart';

class CashierOrderController extends GetxController {
  final _api = Get.find<APIProvider>();

  // Observable variables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Product types and products
  RxList<OrderProductType> productTypes = <OrderProductType>[].obs;
  var selectedTypeIndex = 0.obs;

  // Cart
  RxList<CartItem> cart = <CartItem>[].obs;
  var isProcessingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderingProducts();
  }

  /// Fetch ordering products
  Future<void> fetchOrderingProducts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final res = await _api.getOrderingProducts();

      if (res.statusCode == 200 && res.data != null) {
        final response = OrderProductsResponse.fromJson(res.data);
        productTypes.value = response.data;
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load products (${res.statusCode})';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Get products for selected type
  List<OrderProduct> get selectedProducts {
    if (productTypes.isEmpty || selectedTypeIndex.value >= productTypes.length) {
      return [];
    }
    return productTypes[selectedTypeIndex.value].products;
  }

  /// Add product to cart
  void addToCart(OrderProduct product) {
    final existingIndex = cart.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      cart[existingIndex].increment();
      cart.refresh();
    } else {
      cart.add(CartItem(product: product));
    }

    Get.snackbar(
      'Added to Cart',
      '${product.name} added to cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  /// Remove product from cart
  void removeFromCart(int index) {
    if (index >= 0 && index < cart.length) {
      cart.removeAt(index);
    }
  }

  /// Update cart item quantity
  void updateCartItemQuantity(int index, int quantity) {
    if (index >= 0 && index < cart.length && quantity > 0) {
      cart[index].quantity = quantity;
      cart.refresh();
    }
  }

  /// Increment cart item
  void incrementCartItem(int index) {
    if (index >= 0 && index < cart.length) {
      cart[index].increment();
      cart.refresh();
    }
  }

  /// Decrement cart item
  void decrementCartItem(int index) {
    if (index >= 0 && index < cart.length) {
      if (cart[index].quantity > 1) {
        cart[index].decrement();
        cart.refresh();
      } else {
        removeFromCart(index);
      }
    }
  }

  /// Get cart total
  double get cartTotal {
    return cart.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Get cart items count
  int get cartItemsCount {
    return cart.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Clear cart
  void clearCart() {
    cart.clear();
  }

  /// Place order
  Future<bool> placeOrder() async {
    if (cart.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add items to cart before placing order',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isProcessingOrder.value = true;

      // Create cart IDs list - assuming cart items have IDs
      // If not, you may need to adjust this based on your API requirements
      final cartIds = cart.map((item) => item.product.id).toList();

      final res = await _api.placeOrder(cartIds: cartIds);

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Order placed successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        clearCart();
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to place order (${res.statusCode})',
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
    } finally {
      isProcessingOrder.value = false;
    }
  }

  /// Format currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }

  /// Search products
  List<OrderProduct> searchProducts(String query) {
    if (query.isEmpty) {
      return selectedProducts;
    }

    final searchQuery = query.toLowerCase();
    return selectedProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery) ||
          product.code.toLowerCase().contains(searchQuery);
    }).toList();
  }

  /// Refresh data
  Future<void> refreshData() async {
    await fetchOrderingProducts();
  }
}
