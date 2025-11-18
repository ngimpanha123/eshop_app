import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reports_controller.dart';
import 'admin_reports_view.dart';
import 'cashier_reports_view.dart';

/// Main Reports View - Routes to Admin or Cashier view based on user role
class ReportsView extends GetView<ReportsController> {
  const ReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check if user role is loaded
      if (controller.isLoadingRole.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Route based on user role
      if (controller.isAdmin.value) {
        return const AdminReportsView();
      } else {
        return const CashierReportsView();
      }
    });
  }

}
