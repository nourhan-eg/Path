import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

class BuildStepIndicator extends StatelessWidget {
  final bool isDone;
  final bool isActive;

  const BuildStepIndicator({
    super.key,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    if (isDone) {
      return CircleAvatar(
        radius: 12,
        backgroundColor: colors.primaryGreen,
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }

    if (isActive) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(colors.gold),
        ),
      );
    }

    return CircleAvatar(
      radius: 12,
      backgroundColor: colors.border,
      child: Icon(Icons.circle, size: 8, color: colors.textSecondary),
    );
  }
}
