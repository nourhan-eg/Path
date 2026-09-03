import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

/// Renders the horizontal wrap list of goal category chips.
class GoalCategorySelector extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onTypeSelected;
  final List<String> goalTypes;

  const GoalCategorySelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    this.goalTypes = const [
      'Career',
      'Education',
      'Personal',
      'Health',
      'Financial',
      'other'
    ],
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;
    final cardTheme = Theme.of(context).cardTheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: goalTypes.map((type) {
        final bool isSelected = selectedType == type;
        return Semantics(
          button: true,
          selected: isSelected,
          label: '$type category',
          hint: isSelected ? 'Selected' : 'Double tap to select $type category',
          child: GestureDetector(
            onTap: () => onTypeSelected(type),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colors.primaryGreen : cardTheme.color,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? colors.primaryGreen : colors.border,
                ),
              ),
              child: Text(
                type,
                style: TextStyle(
                  color: isSelected ? colors.onPrimary : colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
