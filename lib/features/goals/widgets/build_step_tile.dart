import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import 'build_step_indicator.dart';

enum BuildStep { analyzing, structuring, finalizing, done }

class BuildStepTile extends StatelessWidget {
  final AppColorScheme colors;
  final String label;
  final BuildStep step;
  final BuildStep currentStep;

  const BuildStepTile({
    super.key,
    required this.colors,
    required this.label,
    required this.step,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = step.index < currentStep.index;
    final isActive = step == currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isActive ? colors.card : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border(left: BorderSide(color: colors.gold, width: 3))
            : Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          BuildStepIndicator(isDone: isDone, isActive: isActive),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isDone || isActive
                    ? colors.textPrimary
                    : colors.textSecondary,
              ),
            ),
          ),
          if (isActive)
            Text(
              'PROCESSING ...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
