import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/statistic_card.dart';
import 'widgets/sales_revenue_card.dart';
import 'widgets/cashier_performance_chart.dart';
import 'widgets/product_type_chart.dart';
import 'widgets/sales_bar_chart.dart';
import 'widgets/cashier_list_widget.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo/posmobile1.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.store, size: 40, color: Color(0xFF5C6BC0));
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'POS',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Colors.black87),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error state
        if (controller.hasError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.fetchDashboardData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Make sure:\n• Server is running on port 9055\n• Using Android Emulator (10.0.2.2)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 768;
            return isMobile ? _buildMobileLayout() : _buildDesktopLayout();
          },
        );
      }),
    );
  }

  Widget _buildMobileLayout() {
    return Obx(() {
      final stat = controller.statistic.value;
      final sales = controller.salesData.value;
      final productType = controller.productTypeData.value;
      final cashiers = controller.cashierList;

      return RefreshIndicator(
        onRefresh: controller.fetchDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Grid
              if (stat != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: StatisticCard(
                        imagePath: 'assets/images/packageblue.png',
                        //icon: Icons.inventory_2_outlined,
                        label: 'ផលិតផល',
                        value: stat.totalProduct.toString(),
                        subtitle: '+${stat.totalProductType}',
                        iconColor: const Color(0xFF5C6BC0),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatisticCard(
                        imagePath: 'assets/images/packagegreen.png',
                        //icon: Icons.category_outlined,
                        label: 'ប្រភេទ',
                        value: stat.totalProductType.toString(),
                        iconColor: const Color(0xFF26A69A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatisticCard(
                        icon: Icons.people_outline,
                        label: 'អ្នកប្រើប្រាស់',
                        value: stat.totalUser.toString(),
                        iconColor: const Color(0xFF66BB6A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatisticCard(
                        icon: Icons.shopping_cart_outlined,
                        label: 'ការលក់',
                        value: stat.totalOrder.toString(),
                        iconColor: const Color(0xFFFF7043),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Cashier List
              if (cashiers.isNotEmpty) ...[
                CashierListWidget(cashiers: cashiers),
                const SizedBox(height: 20),
              ],

              // Product Type Chart
              if (productType != null) ...[
                ProductTypeChart(productTypeData: productType),
                const SizedBox(height: 20),
              ],

              // Sales Bar Chart
              if (sales != null) ...[
                SalesBarChart(salesData: sales),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDesktopLayout() {
    return Obx(() {
      final stat = controller.statistic.value;
      final sales = controller.salesData.value;
      final productType = controller.productTypeData.value;
      final cashiers = controller.cashierList;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: Icon(Icons.person, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'សូមស្វាគមន៍, ចាន់ សុវ៉ាន់ណេត',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'អ្នកប្រើប្រាស់',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF5C6BC0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'មាតិកាប្រាក់ភាគដារ',
                      style: TextStyle(color: Color(0xFF5C6BC0)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statistics and Charts Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - Statistics and Product Type
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Sales Revenue Card
                      if (stat != null) ...[
                        SalesRevenueCard(
                          total: stat.total,
                          percentageChange: stat.totalPercentageIncrease,
                          saleIncreasePreviousDay: stat.saleIncreasePreviousDay,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Product Type Chart
                      if (productType != null) ...[
                        ProductTypeChart(productTypeData: productType),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Right Column - Cashiers and Sales
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Cashier Performance Chart
                      if (cashiers.isNotEmpty) ...[
                        CashierPerformanceChart(cashiers: cashiers),
                        const SizedBox(height: 20),
                      ],

                      // Sales Bar Chart
                      if (sales != null) ...[
                        SalesBarChart(salesData: sales),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
