import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme_config.dart';
import '../../../../routes/app_pages.dart';

class POSTab extends StatelessWidget {
  const POSTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ThemeConfig.primaryColor, ThemeConfig.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ThemeConfig.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.point_of_sale,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Point of Sale',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create new orders and manage transactions',
              style: TextStyle(
                fontSize: 14,
                color: ThemeConfig.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to new mobile-first order flow
                Get.toNamed('/product-list');
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Start New Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConfig.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Get.offAllNamed(Routes.PRODUCT, id: 1);
              },
              icon: const Icon(Icons.inventory_2),
              label: const Text('Browse Products'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
