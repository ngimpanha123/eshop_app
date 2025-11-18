import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme_config.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/user_controller.dart';

class AccountTab extends GetView<UserController> {
  const AccountTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 16),
          _buildAccountSettings(),
          const SizedBox(height: 16),
          _buildActivityLogs(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ThemeConfig.gradientCardDecoration(
        colors: [ThemeConfig.primaryColor, ThemeConfig.primaryLight],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ThemeConfig.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: ThemeConfig.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Ngim Panha',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ngimpanha123@gmail.com',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                controller.currentRoleId.value == 1 ? 'Admin' : 'Cashier',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      decoration: ThemeConfig.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Account Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              Get.snackbar(
                'Info',
                'Edit profile functionality',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              Get.snackbar(
                'Info',
                'Change password functionality',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const Divider(height: 1),
          Obx(() {
            if (controller.currentRoleId.value == 1) {
              return Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.switch_account,
                    title: 'Switch Role',
                    onTap: () {
                      Get.snackbar(
                        'Info',
                        'Switch role functionality',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  const Divider(height: 1),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: ThemeConfig.primaryColor),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildActivityLogs() {
    return Container(
      decoration: ThemeConfig.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recent Activity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(() {
            if (controller.isLoadingLogs.value) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.logs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 48,
                        color: ThemeConfig.textTertiary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No activity logs',
                        style: TextStyle(color: ThemeConfig.textSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.logs.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final log = controller.logs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ThemeConfig.primaryColor.withOpacity(0.2),
                    child: Icon(
                      Icons.info_outline,
                      color: ThemeConfig.primaryColor,
                      size: 20,
                    ),
                  ),
                  title: Text(log.action),
                  subtitle: Text(
                    log.timestamp.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeConfig.textTertiary,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
