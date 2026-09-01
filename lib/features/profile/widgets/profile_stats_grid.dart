import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

/// Renders the Hours Focused tall card and Milestones/Day Streak stacked cards.
class ProfileStatsGrid extends StatelessWidget {
  final int hoursFocused;
  final int milestonesCount;
  final int dayStreak;

  const ProfileStatsGrid({
    super.key,
    this.hoursFocused = 124,
    this.milestonesCount = 15,
    this.dayStreak = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Card: Hours Focused
        Expanded(
          flex: 1,
          child: Container(
            height: 140,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: colors.textSecondary,
                  size: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$hoursFocused',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'HOURS FOCUSED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Right Cards: Milestones & Day Streak
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$milestonesCount',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'MILESTONES',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: colors.textSecondary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.outlined_flag_rounded,
                      color: colors.gold,
                      size: 22,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Day Streak Card
              Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayStreak',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'DAY STREAK',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: colors.textSecondary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.local_fire_department_outlined,
                      color: colors.primaryGreen,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
