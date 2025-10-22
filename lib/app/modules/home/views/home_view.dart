import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constan/color_constan.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: Routes.PRODUCT,
        onGenerateRoute: controller.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          //backgroundColor: Colors.white, // Set background color
          selectedItemColor: color_active_bavigation, // Active item color
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onPageChange,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
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
      }),
    );
  }
}
