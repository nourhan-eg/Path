import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

/// Renders the 2x2 grid of time commitment cards.
class TimeCommitmentGrid extends StatelessWidget {
  final String? selectedCommitment;
  final ValueChanged<String> onCommitmentSelected;
  final List<Map<String, dynamic>> timeOptions;

  const TimeCommitmentGrid({
    super.key,
    required this.selectedCommitment,
    required this.onCommitmentSelected,
    required this.timeOptions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;
    final cardTheme = Theme.of(context).cardTheme;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.8,
      children: timeOptions.map((option) {
        final String label = option['label'];
        final IconData icon = option['icon'];
        final bool isSelected = selectedCommitment == label;

        return Semantics(
          button: true,
          selected: isSelected,
          label: '$label time commitment',
          hint: isSelected ? 'Selected' : 'Double tap to select $label',
          child: GestureDetector(
            onTap: () => onCommitmentSelected(label),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? colors.primaryGreen : colors.card,
                borderRadius: (cardTheme.shape as RoundedRectangleBorder).borderRadius,
                border: Border.all(
                  color: isSelected ? colors.primaryGreen : colors.border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? colors.onPrimary : colors.textPrimary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? colors.onPrimary : colors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
