import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/providers/api_provider.dart';

class ReportsController extends GetxController {
  final _api = Get.find<APIProvider>();

  // Observable variables
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Role detection
  var isLoadingRole = true.obs;
  var isAdmin = false.obs; // true = admin (role_id = 1), false = cashier

  // Date range
  var selectedStartDate = Rx<DateTime?>(null);
  var selectedEndDate = Rx<DateTime?>(null);

  // Report types
  var selectedReportType = 'sale'.obs; // sale, cashier, product

  @override
  void onInit() {
    super.onInit();
    // Set default date range to current week
    final now = DateTime.now();
    selectedStartDate.value = now.subtract(const Duration(days: 7));
    selectedEndDate.value = now;
    
    // Detect user role
    _detectUserRole();
  }

  /// Detect user role (admin or cashier)
  Future<void> _detectUserRole() async {
    try {
      isLoadingRole.value = true;
      
      // TODO: Replace with actual API call to get user profile
      // For now, mock the role detection
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock: Set to admin for testing
      // In production, this should check the actual user role from the profile API
      // Example: final profile = await _api.getProfile();
      // isAdmin.value = profile.roles.any((role) => role.id == 1);
      
      isAdmin.value = true; // Default to admin for now
      
    } catch (e) {
      print('❌ Error detecting user role: $e');
      // Default to cashier (safer default with limited access)
      isAdmin.value = false;
    } finally {
      isLoadingRole.value = false;
    }
  }

  /// Manually set user role (for testing or when role is known)
  void setUserRole(bool isAdminUser) {
    isAdmin.value = isAdminUser;
  }

  /// Generate sale report
  Future<String?> generateSaleReport() async {
    if (!_validateDates()) return null;

    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await _api.generateSaleReport(
        startDate: DateFormat('yyyy-MM-dd').format(selectedStartDate.value!),
        endDate: DateFormat('yyyy-MM-dd').format(selectedEndDate.value!),
      );

      if (res.statusCode == 200 && res.data != null) {
        final base64Pdf = res.data['data'] as String?;
        
        if (base64Pdf != null) {
          Get.snackbar(
            'Success',
            'Sale report generated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
          return base64Pdf;
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to generate sale report';
        Get.snackbar(
          'Error',
          'Failed to generate sale report',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return null;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate cashier report
  Future<String?> generateCashierReport() async {
    if (!_validateDates()) return null;

    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await _api.generateCashierReport(
        startDate: DateFormat('yyyy-MM-dd').format(selectedStartDate.value!),
        endDate: DateFormat('yyyy-MM-dd').format(selectedEndDate.value!),
      );

      if (res.statusCode == 200 && res.data != null) {
        final base64Pdf = res.data['data'] as String?;
        
        if (base64Pdf != null) {
          Get.snackbar(
            'Success',
            'Cashier report generated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
          return base64Pdf;
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to generate cashier report';
        Get.snackbar(
          'Error',
          'Failed to generate cashier report',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return null;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate product report
  Future<String?> generateProductReport() async {
    if (!_validateDates()) return null;

    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await _api.generateProductReport(
        startDate: DateFormat('yyyy-MM-dd').format(selectedStartDate.value!),
        endDate: DateFormat('yyyy-MM-dd').format(selectedEndDate.value!),
      );

      if (res.statusCode == 200 && res.data != null) {
        final base64Pdf = res.data['data'] as String?;
        
        if (base64Pdf != null) {
          Get.snackbar(
            'Success',
            'Product report generated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
          return base64Pdf;
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to generate product report';
        Get.snackbar(
          'Error',
          'Failed to generate product report',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return null;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate report based on selected type
  Future<String?> generateReport() async {
    switch (selectedReportType.value) {
      case 'sale':
        return await generateSaleReport();
      case 'cashier':
        return await generateCashierReport();
      case 'product':
        return await generateProductReport();
      default:
        return null;
    }
  }

  /// Set date range
  void setDateRange(DateTime startDate, DateTime endDate) {
    selectedStartDate.value = startDate;
    selectedEndDate.value = endDate;
  }

  /// Set report type
  void setReportType(String type) {
    selectedReportType.value = type;
  }

  /// Validate dates
  bool _validateDates() {
    if (selectedStartDate.value == null || selectedEndDate.value == null) {
      Get.snackbar(
        'Error',
        'Please select start and end dates',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedStartDate.value!.isAfter(selectedEndDate.value!)) {
      Get.snackbar(
        'Error',
        'Start date must be before end date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  /// Format date
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Get preset date ranges
  Map<String, DateRange> get presetRanges {
    final now = DateTime.now();
    return {
      'Today': DateRange(now, now),
      'Yesterday': DateRange(
        now.subtract(const Duration(days: 1)),
        now.subtract(const Duration(days: 1)),
      ),
      'This Week': DateRange(
        now.subtract(Duration(days: now.weekday - 1)),
        now,
      ),
      'Last Week': DateRange(
        now.subtract(Duration(days: now.weekday + 6)),
        now.subtract(Duration(days: now.weekday)),
      ),
      'This Month': DateRange(
        DateTime(now.year, now.month, 1),
        now,
      ),
      'Last Month': DateRange(
        DateTime(now.year, now.month - 1, 1),
        DateTime(now.year, now.month, 0),
      ),
    };
  }

  /// Apply preset range
  void applyPresetRange(String presetName) {
    final range = presetRanges[presetName];
    if (range != null) {
      selectedStartDate.value = range.start;
      selectedEndDate.value = range.end;
    }
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);
}
