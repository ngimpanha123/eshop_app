import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/dashboard_model.dart';
import '../../../data/providers/api_provider.dart';

class DashboardController extends GetxController {
  final _api = Get.find<APIProvider>();

  // Observable variables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var selectedDate = DateTime.now().obs;

  // Dashboard data
  Rx<Statistic?> statistic = Rx<Statistic?>(null);
  Rx<SalesData?> salesData = Rx<SalesData?>(null);
  Rx<ProductTypeData?> productTypeData = Rx<ProductTypeData?>(null);
  RxList<CashierInfo> cashierList = <CashierInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final today = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final res = await _api.getDashboard(today: today);

      if (res.statusCode == 200 && res.data['dashboard'] != null) {
        final dashboardResponse = DashboardResponse.fromJson(res.data);
        statistic.value = dashboardResponse.dashboard.statistic;
        salesData.value = dashboardResponse.dashboard.salesData;
        productTypeData.value = dashboardResponse.dashboard.productTypeData;
        cashierList.value = dashboardResponse.dashboard.cashierData.data;
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load dashboard (${res.statusCode})';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchDashboardData();
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }

  String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(2)}%';
  }

  Future<void> showDatePicker() async {
    final pickedDate = await Get.dialog<DateTime>(
      AlertDialog(
        title: const Text('Choose a date'),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Today'),
              onTap: () => Get.back(result: DateTime.now()),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Yesterday'),
              onTap: () => Get.back(
                result: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Last week'),
              onTap: () => Get.back(
                result: DateTime.now().subtract(const Duration(days: 7)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Choose a different date'),
              onTap: () async {
                Get.back();
                final date = await _showMaterialDatePicker();
                if (date != null) {
                  changeDate(date);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (pickedDate != null) {
      changeDate(pickedDate);
    }
  }

  Future<DateTime?> _showMaterialDatePicker() async {
    return await Get.generalDialog<DateTime>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CalendarDatePicker(
          initialDate: selectedDate.value,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          onDateChanged: (date) => Get.back(result: date),
        );
      },
    );
  }
}
