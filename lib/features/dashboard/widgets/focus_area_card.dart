import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';

class FocusAreaCard extends StatelessWidget {
  final String weekText;
  final String title;
  final String description;
  final String timeInvested;
  final String tasksDone;
  final VoidCallback? onOptionsPressed;

  const FocusAreaCard({
    super.key,
    this.weekText = 'Week 3 of 8',
    this.title = 'Morning Routine Mastery',
    this.description =
        'Establishing a consistent 30-minute meditation and journaling practice before screen time.',
    this.timeInvested = '12.5 hrs',
    this.tasksDone = '18 / 24',
    this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppColorScheme>() ?? AppColorScheme.light;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? colors.border : const Color(0xFF566252),
          width: 1.2,
        ),
      ),
      child: Stack(
        children: [
          // Background top-right decorative subtle curve accent
          Positioned(
            top: -20,
            right: -15,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF323A30).withValues(alpha: 0.3)
                    : const Color(0xFFF1F5EF),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Week pill & Options menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF30382E)
                            : const Color(0xFFF2F5F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        weekText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFB8C8B4)
                              : const Color(0xFF5A6B56),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: isDark
                          ? colors.textSecondary
                          : const Color(0xFF6B7268),
                      onPressed: onOptionsPressed ?? () {},
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Goal Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 22
                  ),
                ),
                const SizedBox(height: 10),

                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: isDark
                        ? colors.textSecondary
                        : const Color(0xFF6B7268),
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Row
                Row(
                  children: [
                    // Column 1: Time Invested
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time\nInvested',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:  .w400,
                              height: 1.2,
                              color: isDark
                                  ? colors.textSecondary
                                  : const Color(0xFF888F85),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            timeInvested,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? colors.textPrimary
                                  : const Color(0xFF2C332B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Vertical Divider
                    Container(
                      height: 42,
                      width: 1,
                      color: isDark
                          ? colors.border
                          : const Color(0xFFECEAE4),
                    ),
                    const SizedBox(width: 20),

                    // Column 2: Tasks Done
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tasks\nDone',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:  .w400,
                              height: 1.2,
                              color: isDark
                                  ? colors.textSecondary
                                  : const Color(0xFF888F85),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tasksDone,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? colors.textPrimary
                                  : const Color(0xFF2C332B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
