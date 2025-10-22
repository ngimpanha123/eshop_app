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
}
