import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme_config.dart';

class GenerateReportButton extends StatelessWidget {
  final RxBool isLoading;
  final VoidCallback onPressed;

  const GenerateReportButton({
    Key? key,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ElevatedButton.icon(
        onPressed: isLoading.value ? null : onPressed,
        icon: isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.download),
        label: Text(
          isLoading.value ? 'Generating...' : 'Generate Report',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: ThemeConfig.primaryColor,
        ),
      );
    });
  }
}
