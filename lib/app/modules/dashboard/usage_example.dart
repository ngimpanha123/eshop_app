// USAGE EXAMPLES FOR DASHBOARD
// This file contains examples of how to use and navigate to the dashboard

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

// ============================================
// EXAMPLE 1: Simple Navigation Button
// ============================================
class DashboardNavigationButton extends StatelessWidget {
  const DashboardNavigationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(Routes.DASHBOARD);
      },
      child: const Text('Open Dashboard'),
    );
  }
}

// ============================================
// EXAMPLE 2: Dashboard Shortcut in AppBar
// ============================================
class AppBarWithDashboard extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('POS System'),
      actions: [
        IconButton(
          icon: const Icon(Icons.dashboard),
          tooltip: 'Dashboard',
          onPressed: () {
            Get.toNamed(Routes.DASHBOARD);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ============================================
// EXAMPLE 3: Adding Dashboard to Drawer Menu
// ============================================
class DrawerWithDashboard extends StatelessWidget {
  const DrawerWithDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'POS Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Get.toNamed(Routes.DASHBOARD);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Products'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.PRODUCT);
            },
          ),
          // Add more menu items...
        ],
      ),
    );
  }
}

// ============================================
// EXAMPLE 4: Dashboard Card/Widget
// ============================================
class DashboardAccessCard extends StatelessWidget {
  const DashboardAccessCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.DASHBOARD);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.analytics,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              const Text(
                'View Dashboard',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sales, Stats & Analytics',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// EXAMPLE 5: Programmatic Navigation
// ============================================
class DashboardNavigationService {
  // Navigate to dashboard
  static void openDashboard() {
    Get.toNamed(Routes.DASHBOARD);
  }

  // Navigate to dashboard and remove previous routes
  static void openDashboardAsRoot() {
    Get.offAllNamed(Routes.DASHBOARD);
  }

  // Navigate to dashboard with transition
  static void openDashboardWithTransition() {
    Get.toNamed(Routes.DASHBOARD);
    // Note: For custom transitions, define them in app_pages.dart GetPage
  }

  // Navigate to dashboard with specific date
  static void openDashboardWithDate(DateTime date) {
    Get.toNamed(
      Routes.DASHBOARD,
      arguments: {'selectedDate': date},
    );
  }
}

// ============================================
// EXAMPLE 6: Bottom Navigation with Dashboard
// ============================================
class BottomNavWithDashboard extends StatefulWidget {
  const BottomNavWithDashboard({Key? key}) : super(key: key);

  @override
  State<BottomNavWithDashboard> createState() => _BottomNavWithDashboardState();
}

class _BottomNavWithDashboardState extends State<BottomNavWithDashboard> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    Routes.PRODUCT,
    Routes.DASHBOARD,
    Routes.CART,
    Routes.APP_SETTINGS,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Get.offAllNamed(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

// ============================================
// EXAMPLE 7: Using Dashboard Controller
// ============================================
/*
import 'package:get/get.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';

void exampleControllerUsage() {
  // Get the controller instance
  final dashboardController = Get.find<DashboardController>();
  
  // Refresh dashboard data
  dashboardController.fetchDashboardData();
  
  // Change date
  dashboardController.changeDate(DateTime(2024, 10, 26));
  
  // Access data
  final statistic = dashboardController.statistic.value;
  print('Total Sales: ${statistic?.total}');
  
  // Format currency
  final formatted = dashboardController.formatCurrency(16000);
  print('Formatted: $formatted'); // Output: 16,000
}
*/
