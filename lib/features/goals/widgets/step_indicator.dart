import 'package:flutter/material.dart';

/// Renders the 4-segment step progress bar.
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final bool isActive = index < currentStep;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            height: 4,
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).secondaryHeaderColor
                  : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
