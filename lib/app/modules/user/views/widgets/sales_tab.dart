import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_config.dart';
import '../../../../config/theme_config.dart';
import '../../controllers/user_controller.dart';

class SalesTab extends GetView<UserController> {
  const SalesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 64, color: ThemeConfig.errorColor),
              const SizedBox(height: 16),
              Text(controller.errorMessage.value),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchSales(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: Column(
          children: [
            _buildSalesStats(),
            Expanded(child: _buildSalesList()),
            _buildPagination(),
          ],
        ),
      );
    });
  }

  Widget _buildSalesStats() {
    return Obx(() {
      final totalSales = controller.salesList.fold(
        0.0,
        (sum, sale) => sum + sale.totalPrice,
      );
      final totalOrders = controller.salesList.length;

      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: ThemeConfig.gradientCardDecoration(
          colors: [ThemeConfig.primaryColor, ThemeConfig.primaryDark],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Sales',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${controller.formatCurrency(totalSales)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white, size: 32),
                  const SizedBox(height: 4),
                  Text(
                    totalOrders.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Orders',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSalesList() {
    return Obx(() {
      if (controller.salesList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long,
                  size: 64, color: ThemeConfig.textTertiary),
              const SizedBox(height: 16),
              Text(
                'No sales found',
                style: TextStyle(color: ThemeConfig.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                'Your sales will appear here',
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeConfig.textTertiary,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.salesList.length,
        itemBuilder: (context, index) {
          final sale = controller.salesList[index];
          return _buildSaleCard(sale);
        },
      );
    });
  }

  Widget _buildSaleCard(sale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: ThemeConfig.cardDecoration(),
      child: InkWell(
        onTap: () => _showSaleDetails(sale),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeConfig.primaryColor,
                          ThemeConfig.primaryLight
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#${sale.receiptNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildPlatformBadge(sale.platform),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 16, color: ThemeConfig.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    controller.formatDate(sale.orderedAt),
                    style: TextStyle(
                      fontSize: 13,
                      color: ThemeConfig.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${sale.details.length} items',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeConfig.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '\$${controller.formatCurrency(sale.totalPrice)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.successColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformBadge(String platform) {
    Color color;
    IconData icon;

    switch (platform.toLowerCase()) {
      case 'web':
        color = ThemeConfig.infoColor;
        icon = Icons.web;
        break;
      case 'mobile':
        color = ThemeConfig.successColor;
        icon = Icons.phone_android;
        break;
      default:
        color = ThemeConfig.textSecondary;
        icon = Icons.devices;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            platform,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Obx(() {
      final pagination = controller.pagination.value;
      if (pagination == null || pagination.totalPage <= 1) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeConfig.darkSurface,
          border: Border(top: BorderSide(color: ThemeConfig.darkBorder)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Page ${controller.currentPage.value} of ${pagination.totalPage}',
              style: TextStyle(color: ThemeConfig.textSecondary),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: controller.currentPage.value > 1
                      ? () => controller.changePage(controller.currentPage.value - 1)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: controller.currentPage.value < pagination.totalPage
                      ? () => controller.changePage(controller.currentPage.value + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _showSaleDetails(sale) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Sale #${sale.receiptNumber}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                controller.formatDate(sale.orderedAt),
                style: TextStyle(color: ThemeConfig.textSecondary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sale.details.length,
                  itemBuilder: (context, index) {
                    final detail = sale.details[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: ThemeConfig.cardDecoration(),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              AppConfig.getImageUrl(detail.product.image),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: ThemeConfig.darkBorder,
                                  child: Icon(
                                    Icons.image,
                                    color: ThemeConfig.textTertiary,
                                  ),
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
                                  detail.product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${detail.qty} x \$${controller.formatCurrency(detail.unitPrice)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ThemeConfig.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${controller.formatCurrency(detail.subtotal)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${controller.formatCurrency(sale.totalPrice)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.successColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final pdf = await controller
                            .getOrderInvoice(sale.receiptNumber);
                        if (pdf != null) {
                          Get.snackbar('Success', 'Invoice downloaded');
                        }
                      },
                      icon: const Icon(Icons.print),
                      label: const Text('Print Invoice'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
