import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/providers/api_provider.dart';

class CashierSalesController extends GetxController {
  final _api = Get.find<APIProvider>();

  // Observable variables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Sales data
  RxList<SaleModel> salesList = <SaleModel>[].obs;
  Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);
  var currentPage = 1.obs;
  final int limit = 10;

  // Selected sale detail
  Rx<SaleModel?> selectedSale = Rx<SaleModel?>(null);
  var isLoadingDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  /// Fetch sales list
  Future<void> fetchSales({bool showLoading = true}) async {
    try {
      if (showLoading) {
        isLoading.value = true;
      }
      hasError.value = false;
      errorMessage.value = '';

      final res = await _api.getCashierSales(
        page: currentPage.value,
        limit: limit,
      );

      if (res.statusCode == 200 && res.data != null) {
        final response = SaleListResponse.fromJson(res.data);
        salesList.value = response.data;
        pagination.value = response.pagination;
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load sales (${res.statusCode})';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  /// Fetch sale detail
  Future<void> fetchSaleDetail(int saleId) async {
    try {
      isLoadingDetail.value = true;

      final res = await _api.getCashierSaleById(saleId: saleId);

      if (res.statusCode == 200 && res.data != null) {
        final response = SaleDetailResponse.fromJson(res.data);
        selectedSale.value = response.data;
      } else {
        Get.snackbar(
          'Error',
          'Failed to load sale detail',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingDetail.value = false;
    }
  }

  /// Change page
  void changePage(int page) {
    if (page >= 1 && page <= (pagination.value?.totalPage ?? 1)) {
      currentPage.value = page;
      fetchSales(showLoading: false);
    }
  }

  /// Delete sale
  Future<bool> deleteSale(int saleId) async {
    try {
      final res = await _api.deleteCashierSale(saleId: saleId);

      if (res.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Sale deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchSales(showLoading: false);
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete sale',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Get order invoice PDF
  Future<String?> getOrderInvoice(String receiptNumber) async {
    try {
      final res = await _api.getOrderInvoice(receiptNumber: receiptNumber);

      if (res.statusCode == 200 && res.data != null) {
        return res.data['data'] as String?; // base64 PDF
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get invoice',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Format currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }

  /// Format date
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  /// Refresh data
  Future<void> refreshData() async {
    await fetchSales(showLoading: false);
  }
}
