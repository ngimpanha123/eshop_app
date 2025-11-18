import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme_config.dart';

class ReportTypeSelector extends StatelessWidget {
  final RxString selectedType;
  final List<ReportTypeOption> options;
  final Function(String) onTypeSelected;

  const ReportTypeSelector({
    Key? key,
    required this.selectedType,
    required this.options,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ThemeConfig.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: options.map((option) {
              return _buildReportTypeChip(
                option.label,
                option.value,
                option.icon,
                option.color,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeChip(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Obx(() {
      final isSelected = selectedType.value == value;
      return ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : color),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTypeSelected(value),
        backgroundColor: color.withOpacity(0.1),
        selectedColor: color,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );
    });
  }
}

class ReportTypeOption {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  ReportTypeOption({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
