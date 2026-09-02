import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';

class StatisticsCardWidget extends StatelessWidget {
  final String investedText;
  final String tasksText;
  final String evidenceText;

  const StatisticsCardWidget({
    super.key,
    this.investedText = '24h',
    this.tasksText = '18/28',
    this.evidenceText = '12',
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppColorScheme>() ?? AppColorScheme.light;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? colors.border : const Color(0xFFE4E1D8),
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Section 1: Time Invested
            Expanded(
              child: _StatSectionItem(
                icon: Icons.access_time_rounded,
                value: investedText,
                label: 'INVESTED',
                isDark: isDark,
                colors: colors,
              ),
            ),
            // Vertical Divider 1
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: isDark ? colors.border : const Color(0xFFEBE8E0),
            ),
            // Section 2: Tasks
            Expanded(
              child: _StatSectionItem(
                icon: Icons.check_circle_outline_rounded,
                value: tasksText,
                label: 'TASKS',
                isDark: isDark,
                colors: colors,
              ),
            ),
            // Vertical Divider 2
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: isDark ? colors.border : const Color(0xFFEBE8E0),
            ),
            // Section 3: Evidence
            Expanded(
              child: _StatSectionItem(
                icon: Icons.menu_book_rounded,
                value: evidenceText,
                label: 'EVIDENCE',
                isDark: isDark,
                colors: colors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatSectionItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isDark;
  final AppColorScheme colors;

  const _StatSectionItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.isDark,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final darkTextColor = isDark ? colors.textPrimary : const Color(0xFF333C30);
    final mutedTextColor = isDark ? colors.textSecondary : const Color(0xFF757D71);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 22,
          color: darkTextColor,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: mutedTextColor,
          ),
        ),
      ],
    );
  }
}
