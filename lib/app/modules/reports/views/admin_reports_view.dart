import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme_config.dart';
import '../controllers/reports_controller.dart';
import 'widgets/report_type_selector.dart';
import 'widgets/date_range_selector.dart';
import 'widgets/preset_ranges.dart';
import 'widgets/generate_report_button.dart';
import 'widgets/report_pdf_dialog.dart';

/// Admin Reports View - Full access to all report types
class AdminReportsView extends GetView<ReportsController> {
  const AdminReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Reports'),
        backgroundColor: ThemeConfig.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Reset to default values
          controller.selectedStartDate.value = 
              DateTime.now().subtract(const Duration(days: 7));
          controller.selectedEndDate.value = DateTime.now();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 16),
              ReportTypeSelector(
                selectedType: controller.selectedReportType,
                options: _getReportTypeOptions(),
                onTypeSelected: (type) => controller.setReportType(type),
              ),
              const SizedBox(height: 16),
              DateRangeSelector(
                startDate: controller.selectedStartDate,
                endDate: controller.selectedEndDate,
                onStartDateSelected: (date) {
                  controller.selectedStartDate.value = date;
                },
                onEndDateSelected: (date) {
                  controller.selectedEndDate.value = date;
                },
                formatDate: controller.formatDate,
              ),
              const SizedBox(height: 16),
              PresetRanges(
                presetRanges: controller.presetRanges,
                onPresetSelected: (presetName) {
                  controller.applyPresetRange(presetName);
                },
              ),
              const SizedBox(height: 24),
              GenerateReportButton(
                isLoading: controller.isLoading,
                onPressed: () => _generateReport(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ThemeConfig.gradientCardDecoration(
        colors: [ThemeConfig.primaryColor, ThemeConfig.primaryDark],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Reports',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Generate comprehensive reports',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Full access to all report types',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ReportTypeOption> _getReportTypeOptions() {
    return [
      ReportTypeOption(
        label: 'Sale Report',
        value: 'sale',
        icon: Icons.point_of_sale,
        color: ThemeConfig.successColor,
      ),
      ReportTypeOption(
        label: 'Cashier Report',
        value: 'cashier',
        icon: Icons.person,
        color: ThemeConfig.primaryColor,
      ),
      ReportTypeOption(
        label: 'Product Report',
        value: 'product',
        icon: Icons.inventory,
        color: ThemeConfig.warningColor,
      ),
    ];
  }

  Future<void> _generateReport() async {
    final pdf = await controller.generateReport();
    if (pdf != null) {
      ReportPdfDialog.show(
        base64Pdf: pdf,
        reportType: controller.selectedReportType.value,
      );
    }
  }

  void _showInfoDialog() {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: ThemeConfig.primaryColor),
            SizedBox(width: 12),
            Text('Admin Reports'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Report Types:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              '📊 Sale Report',
              'Comprehensive sales data including revenue, transactions, and trends',
            ),
            const SizedBox(height: 8),
            _buildInfoItem(
              '👤 Cashier Report',
              'Individual cashier performance and transaction history',
            ),
            const SizedBox(height: 8),
            _buildInfoItem(
              '📦 Product Report',
              'Product sales statistics, inventory movement, and top performers',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: ThemeConfig.textSecondary,
          ),
        ),
      ],
    );
  }
}
