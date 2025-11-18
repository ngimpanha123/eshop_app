import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme_config.dart';

class DateRangeSelector extends StatelessWidget {
  final Rx<DateTime?> startDate;
  final Rx<DateTime?> endDate;
  final Function(DateTime) onStartDateSelected;
  final Function(DateTime) onEndDateSelected;
  final String Function(DateTime) formatDate;

  const DateRangeSelector({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
    required this.formatDate,
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
            'Date Range',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  'Start Date',
                  startDate,
                  onStartDateSelected,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  'End Date',
                  endDate,
                  onEndDateSelected,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    String label,
    Rx<DateTime?> dateRx,
    Function(DateTime) onDateSelected,
  ) {
    return Obx(() {
      return InkWell(
        onTap: () => _selectDate(dateRx, onDateSelected),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ThemeConfig.darkCard,
            border: Border.all(color: ThemeConfig.darkBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 18,
                color: ThemeConfig.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        color: ThemeConfig.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateRx.value != null
                          ? formatDate(dateRx.value!)
                          : 'Select date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: dateRx.value != null
                            ? ThemeConfig.textPrimary
                            : ThemeConfig.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _selectDate(
    Rx<DateTime?> dateRx,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: dateRx.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeConfig.darkTheme,
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}
