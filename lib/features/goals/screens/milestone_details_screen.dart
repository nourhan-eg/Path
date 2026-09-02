import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';
import 'package:path_app/core/widgets/custom_app_bar.dart';
import 'package:path_app/models/milestone_model.dart';

class MilestoneDetailsScreen extends StatelessWidget {
  final MilestoneModel milestone;

  const MilestoneDetailsScreen({
    super.key,
    required this.milestone,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppColorScheme>() ?? AppColorScheme.light;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: 'Milestone Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Milestone Status Badge
              _StatusBadge(status: milestone.status, colors: colors, isDark: isDark),

              const SizedBox(height: 16),

              // Title
              Text(
                milestone.title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? colors.textPrimary : const Color(0xFF2C332B),
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                milestone.description.isNotEmpty
                    ? milestone.description
                    : 'Milestone order #${milestone.order} in your journey path.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: isDark ? colors.textSecondary : const Color(0xFF5A6357),
                ),
              ),

              const SizedBox(height: 28),

              // If Locked Banner
              if (milestone.isLocked) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2E2B23)
                        : const Color(0xFFFFF9EE),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF5E543A)
                          : const Color(0xFFFFE8B2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFFC8A96B),
                        size: 24,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Milestone Locked',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC8A96B),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Complete current active milestones to unlock this section.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF8A7750),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // Milestone Progress Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? colors.border : const Color(0xFFE4E1D8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Milestone Progress',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? colors.textPrimary
                                : const Color(0xFF333C30),
                          ),
                        ),
                        Text(
                          '${(milestone.progress * 100).round()}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: milestone.progress,
                        minHeight: 8,
                        backgroundColor: isDark
                            ? const Color(0xFF383D33)
                            : const Color(0xFFE8E5DC),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          milestone.isCompleted
                              ? colors.primaryGreen
                              : (milestone.isCurrent
                                  ? colors.gold
                                  : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final MilestoneStatus status;
  final AppColorScheme colors;
  final bool isDark;

  const _StatusBadge({
    required this.status,
    required this.colors,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case MilestoneStatus.completed:
        bg = isDark ? const Color(0xFF2C392B) : const Color(0xFFEFF4EE);
        fg = isDark ? const Color(0xFF9BB298) : const Color(0xFF4A5C48);
        label = 'COMPLETED';
        icon = Icons.check_circle_rounded;
        break;
      case MilestoneStatus.current:
        bg = isDark ? const Color(0xFF3A3324) : const Color(0xFFFFF9ED);
        fg = colors.gold;
        label = 'IN PROGRESS';
        icon = Icons.star_rounded;
        break;
      case MilestoneStatus.locked:
        bg = isDark ? const Color(0xFF2B2C27) : const Color(0xFFF3F2EC);
        fg = isDark ? const Color(0xFF888B83) : const Color(0xFF7A7D75);
        label = 'LOCKED';
        icon = Icons.lock_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
