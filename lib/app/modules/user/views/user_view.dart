import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme_config.dart';
import '../controllers/user_controller.dart';
import 'widgets/pos_tab.dart';
import 'widgets/sales_tab.dart';
import 'widgets/account_tab.dart';

class UserView extends GetView<UserController> {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Obx(() {
            return TabBar(
              controller: controller.tabController,
              physics: controller.canSwitchTabs
                  ? const ScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              tabs: [
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_shopping_cart),
                      const SizedBox(width: 8),
                      const Text('POS'),
                      if (!controller.canSwitchTabs)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.lock,
                            size: 12,
                            color: ThemeConfig.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                const Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long),
                      SizedBox(width: 8),
                      Text('Sales'),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 8),
                      const Text('Account'),
                      if (!controller.canSwitchTabs)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.lock,
                            size: 12,
                            color: ThemeConfig.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              onTap: (index) {
                if (!controller.canSwitchTabs && (index == 0 || index == 2)) {
                  Get.snackbar(
                    'Access Denied',
                    'Only admins can switch to POS and Account tabs',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: ThemeConfig.errorColor.withOpacity(0.8),
                    colorText: Colors.white,
                  );
                  // Prevent tab change by resetting to Sales tab
                  controller.tabController.index = 1;
                }
              },
            );
          }),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        physics: controller.canSwitchTabs
            ? const ScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: [
          const POSTab(),
          const SalesTab(),
          const AccountTab(),
        ],
      ),
    );
  }
}
