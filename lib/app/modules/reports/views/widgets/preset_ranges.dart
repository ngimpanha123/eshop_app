import 'package:flutter/material.dart';
import '../../../../config/theme_config.dart';

class PresetRanges extends StatelessWidget {
  final Map<String, dynamic> presetRanges;
  final Function(String) onPresetSelected;

  const PresetRanges({
    Key? key,
    required this.presetRanges,
    required this.onPresetSelected,
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
            'Quick Select',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presetRanges.keys.map((presetName) {
              return _buildPresetButton(presetName);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(String presetName) {
    return OutlinedButton(
      onPressed: () => onPresetSelected(presetName),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: ThemeConfig.primaryColor.withOpacity(0.5)),
      ),
      child: Text(presetName),
    );
  }
}
