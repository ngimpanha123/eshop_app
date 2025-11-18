import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_config.dart';
import '../../../config/theme_config.dart';
import '../controllers/cashier_order_controller.dart';

class CashierOrderView extends GetView<CashierOrderController> {
  const CashierOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: ThemeConfig.errorColor),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchOrderingProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Row(
          children: [
            Expanded(flex: 3, child: _buildProductsSection()),
            Container(width: 1, color: ThemeConfig.darkBorder),
            Expanded(flex: 2, child: _buildCartSection()),
          ],
        );
      }),
    );
  }

  Widget _buildProductsSection() {
    return Column(
      children: [
        _buildProductTypesTabs(),
        Expanded(child: _buildProductsGrid()),
      ],
    );
  }

  Widget _buildProductTypesTabs() {
    return Obx(() {
      if (controller.productTypes.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: ThemeConfig.darkSurface,
          border: Border(bottom: BorderSide(color: ThemeConfig.darkBorder)),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: controller.productTypes.length,
          itemBuilder: (context, index) {
            final type = controller.productTypes[index];
            final isSelected = controller.selectedTypeIndex.value == index;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: ChoiceChip(
                label: Text(type.name),
                selected: isSelected,
                onSelected: (_) => controller.selectedTypeIndex.value = index,
                backgroundColor: ThemeConfig.darkCard,
                selectedColor: ThemeConfig.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : ThemeConfig.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildProductsGrid() {
    return Obx(() {
      final products = controller.selectedProducts;

      if (products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2, size: 64, color: ThemeConfig.textTertiary),
              const SizedBox(height: 16),
              Text('No products available', style: TextStyle(color: ThemeConfig.textSecondary)),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(product);
        },
      );
    });
  }

  Widget _buildProductCard(product) {
    return InkWell(
      onTap: () => controller.addToCart(product),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: ThemeConfig.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  AppConfig.getImageUrl(product.image),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: ThemeConfig.darkBorder,
                      child: Icon(Icons.image_not_supported,
                        color: ThemeConfig.textTertiary, size: 48),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.code,
                    style: TextStyle(fontSize: 10, color: ThemeConfig.textTertiary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${controller.formatCurrency(product.unitPrice)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSection() {
    return Container(
      color: ThemeConfig.darkSurface,
      child: Column(
        children: [
          _buildCartHeader(),
          Expanded(child: _buildCartItems()),
          _buildCartSummary(),
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  Widget _buildCartHeader() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: ThemeConfig.darkBorder)),
        ),
        child: Row(
          children: [
            const Icon(Icons.shopping_cart),
            const SizedBox(width: 8),
            Text(
              'Cart (${controller.cartItemsCount})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (controller.cart.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmClearCart(),
                tooltip: 'Clear Cart',
              ),
          ],
        ),
      );
    });
  }

  Widget _buildCartItems() {
    return Obx(() {
      if (controller.cart.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 64, color: ThemeConfig.textTertiary),
              const SizedBox(height: 16),
              Text('Cart is empty', style: TextStyle(color: ThemeConfig.textSecondary)),
              const SizedBox(height: 8),
              Text(
                'Add products to get started',
                style: TextStyle(fontSize: 12, color: ThemeConfig.textTertiary),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: controller.cart.length,
        itemBuilder: (context, index) {
          final item = controller.cart[index];
          return _buildCartItem(item, index);
        },
      );
    });
  }

  Widget _buildCartItem(item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: ThemeConfig.cardDecoration(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              AppConfig.getImageUrl(item.product.image),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: ThemeConfig.darkBorder,
                  child: Icon(Icons.image_not_supported, color: ThemeConfig.textTertiary),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${controller.formatCurrency(item.product.unitPrice)}',
                  style: TextStyle(fontSize: 12, color: ThemeConfig.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 18),
                    onPressed: () => controller.decrementCartItem(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    constraints: const BoxConstraints(minWidth: 32),
                    decoration: BoxDecoration(
                      color: ThemeConfig.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    onPressed: () => controller.incrementCartItem(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '\$${controller.formatCurrency(item.subtotal)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: ThemeConfig.successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: ThemeConfig.darkBorder)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Items:', style: TextStyle(fontSize: 14)),
                Text('${controller.cartItemsCount}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '\$${controller.formatCurrency(controller.cartTotal)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ThemeConfig.successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCheckoutButton() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: controller.cart.isEmpty || controller.isProcessingOrder.value
              ? null
              : () => _confirmCheckout(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            backgroundColor: ThemeConfig.successColor,
          ),
          child: controller.isProcessingOrder.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Place Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
    });
  }

  void _confirmClearCart() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear the cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: ThemeConfig.errorColor),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _confirmCheckout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Items: ${controller.cartItemsCount}'),
            const SizedBox(height: 8),
            Text(
              'Total Amount: \$${controller.formatCurrency(controller.cartTotal)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await controller.placeOrder();
              if (success) {
                // Navigate to receipt or sales list
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
