import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme_config.dart';

class ReportPdfDialog extends StatelessWidget {
  final String base64Pdf;
  final String reportType;

  const ReportPdfDialog({
    Key? key,
    required this.base64Pdf,
    required this.reportType,
  }) : super(key: key);

  static void show({required String base64Pdf, required String reportType}) {
    Get.dialog(
      ReportPdfDialog(base64Pdf: base64Pdf, reportType: reportType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildContent(),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Report Generated',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeConfig.errorColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.picture_as_pdf,
              size: 64,
              color: ThemeConfig.errorColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Report has been generated successfully',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            reportType.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              color: ThemeConfig.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'PDF Ready for Download',
            style: TextStyle(
              fontSize: 12,
              color: ThemeConfig.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement share functionality
              Get.snackbar(
                'Share',
                'Share functionality will be implemented',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement download functionality
              Get.snackbar(
                'Download',
                'PDF download functionality will be implemented',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
