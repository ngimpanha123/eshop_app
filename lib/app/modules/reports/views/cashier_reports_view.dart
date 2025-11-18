import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme_config.dart';
import '../controllers/reports_controller.dart';
import 'widgets/date_range_selector.dart';
import 'widgets/preset_ranges.dart';
import 'widgets/generate_report_button.dart';
import 'widgets/report_pdf_dialog.dart';

/// Cashier Reports View - Limited to sale reports only
class CashierReportsView extends GetView<ReportsController> {
  const CashierReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Force sale report type for cashiers
    controller.setReportType('sale');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sales Reports'),
        backgroundColor: ThemeConfig.successColor,
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
              _buildReportTypeInfo(),
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
              const SizedBox(height: 16),
              _buildInfoCard(),
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
        colors: [ThemeConfig.successColor, ThemeConfig.successColor.withOpacity(0.7)],
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
                  Icons.receipt_long,
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
                      'Sales Reports',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'View your sales performance',
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
        ],
      ),
    );
  }

  Widget _buildReportTypeInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ThemeConfig.cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ThemeConfig.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.point_of_sale,
              color: ThemeConfig.successColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sale Report',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Generate reports for your sales activities',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeConfig.successColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'ACTIVE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: ThemeConfig.successColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeConfig.infoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeConfig.infoColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: ThemeConfig.infoColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cashier Access',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ThemeConfig.infoColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You have access to sales reports only. Contact admin for additional report types.',
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeConfig.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateReport() async {
    final pdf = await controller.generateSaleReport();
    if (pdf != null) {
      ReportPdfDialog.show(
        base64Pdf: pdf,
        reportType: 'sale',
      );
    }
  }
}
