import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/providers/api_provider.dart';

class UserController extends GetxController with GetTickerProviderStateMixin {
  final _api = Get.find<APIProvider>();

  // Tab controller
  late TabController tabController;

  // Observable variables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Profile data
  Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  var currentRoleId = 1.obs; // Default to admin

  // Sales data
  RxList<SaleModel> salesList = <SaleModel>[].obs;
  Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);
  var currentPage = 1.obs;
  final int limit = 10;

  // Selected sale detail
  Rx<SaleModel?> selectedSale = Rx<SaleModel?>(null);
  var isLoadingDetail = false.obs;

  // Logs
  RxList<ProfileLog> logs = <ProfileLog>[].obs;
  var isLoadingLogs = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    fetchProfileData();
    fetchSales();
    fetchProfileLogs();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Fetch profile data (mock for now, should call API)
  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      // Mock profile data - replace with actual API call
      // For now, we'll check if user has admin role (role_id = 1)
      // You should call a proper API endpoint to get the user profile
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock: assuming current user role from storage or API
      currentRoleId.value = 1; // This should come from actual user data
      
      isLoading.value = false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
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

  /// Fetch profile logs
  Future<void> fetchProfileLogs({bool showLoading = true}) async {
    try {
      if (showLoading) {
        isLoadingLogs.value = true;
      }

      final res = await _api.getProfileLogs(
        page: 1,
        limit: 10,
      );

      if (res.statusCode == 200 && res.data != null) {
        final response = ProfileLogsResponse.fromJson(res.data);
        logs.value = response.data;
      }
    } catch (e) {
      print('❌ Error fetching profile logs: $e');
    } finally {
      if (showLoading) {
        isLoadingLogs.value = false;
      }
    }
  }

  /// Change sales page
  void changePage(int page) {
    if (page >= 1 && page <= (pagination.value?.totalPage ?? 1)) {
      currentPage.value = page;
      fetchSales(showLoading: false);
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

  /// Check if user can switch tabs
  bool get canSwitchTabs => currentRoleId.value == 1; // Only admin can switch

  /// Refresh data
  Future<void> refreshData() async {
    await Future.wait([
      fetchSales(showLoading: false),
      fetchProfileLogs(showLoading: false),
    ]);
  }
}
