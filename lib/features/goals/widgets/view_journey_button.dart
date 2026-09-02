import 'package:flutter/material.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/core/theme/app_color.dart';

class ViewJourneyButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ViewJourneyButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppColorScheme>() ?? AppColorScheme.light;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor =
        isDark ? const Color(0xFF6B7E68) : colors.primaryGreen;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed ??
            () {
              Navigator.pushNamed(context, AppRouter.signatureJourneyRoute);
            },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.alt_route_rounded,
              size: 22,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            const Text(
              'View Journey',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
