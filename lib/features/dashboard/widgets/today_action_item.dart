import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';

class TodayActionItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final ValueChanged<bool?>? onToggle;
  final VoidCallback? onStartPressed;

  const TodayActionItem({
    super.key,
    required this.title,
    required this.isCompleted,
    this.onToggle,
    this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppColorScheme>() ?? AppColorScheme.light;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? colors.border : const Color(0xFFECEAE4),
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox toggle icon
          GestureDetector(
            onTap: () => onToggle?.call(!isCompleted),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF81957B)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF81957B)
                      : (isDark ? colors.border : const Color(0xFFC7C7C0)),
                  width: 1.5,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 14),

          // Task Title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isCompleted
                    ? (isDark ? const Color(0xFF7A8077) : const Color(0xFF9AA097))
                    : (isDark ? colors.textPrimary : const Color(0xFF333B31)),
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: isDark ? const Color(0xFF7A8077) : const Color(0xFF9AA097),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Start Button
          InkWell(
            onTap: onStartPressed,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF424D3F)
                    : const Color(0xFFA5B6A7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Start',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFE5EDE3) : const Color(0xFF283626),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
