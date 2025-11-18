import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme_config.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [ThemeConfig.primaryColor, ThemeConfig.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 36, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'User Name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'user@email.com',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildSectionHeader('Main'),
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'User',
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.USER);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(Routes.DASHBOARD, id: 1);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.add_shopping_cart,
                    title: 'New Order',
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(Routes.CASHIER_ORDER, id: 1);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.receipt_long,
                    title: 'My Sales',
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(Routes.CASHIER_SALES, id: 1);
                    },
                  ),
                  
                  const Divider(height: 32),
                  
                  _buildSectionHeader('Admin'),
                  _buildMenuItem(
                    icon: Icons.point_of_sale,
                    title: 'All Sales',
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.ADMIN_SALES);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.inventory_2,
                    title: 'Products',
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(Routes.PRODUCT, id: 1);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.category,
                    title: 'Manage Products',
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.ADMIN_PRODUCT);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.people,
                    title: 'Users',
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.ADMIN_USER);
                    },
                  ),
                  
                  const Divider(height: 32),
                  
                  _buildSectionHeader('Tools'),
                  _buildMenuItem(
                    icon: Icons.bar_chart,
                    title: 'Reports',
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(Routes.REPORTS, id: 1);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.search,
                    title: 'Search Products',
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(Routes.SEARCH_PRODUCT, id: 1);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(Routes.APP_SETTINGS, id: 1);
                    },
                  ),
                ],
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: ThemeConfig.lightBorder)),
              ),
              child: _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                iconColor: ThemeConfig.errorColor,
                textColor: ThemeConfig.errorColor,
                onTap: () {
                  _confirmLogout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: ThemeConfig.textTertiary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? ThemeConfig.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? ThemeConfig.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      dense: true,
    );
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final storage = Get.find<StorageService>();
              storage.clearToken();
              Get.back();
              Get.offAllNamed(Routes.LOGIN);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
