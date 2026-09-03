import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';
import 'package:path_app/models/goal_model.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  String _formatDeadline(DateTime date) {
    const months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;
    final progress = goal.overallProgress.clamp(0.0, 1.0).toDouble();
    final deadlinePassed = goal.deadline.isBefore(DateTime.now());

    return Semantics(
      button: true,
      label: 'Open ${goal.title}',
      child: Material(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(18, 18, 14, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        goal.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.arrow_forward_rounded,
                        color: colors.textSecondary, size: 22),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _GoalMeta(
                      icon: Icons.sell_outlined,
                      label: goal.category.isEmpty ? 'Personal' : goal.category,
                      colors: colors,
                    ),
                    _GoalMeta(
                      icon: deadlinePassed
                          ? Icons.warning_amber_rounded
                          : Icons.event_outlined,
                      label: deadlinePassed
                          ? 'Deadline passed'
                          : 'Due ${_formatDeadline(goal.deadline)}',
                      colors: colors,
                      accent: deadlinePassed ? colors.error : null,
                    ),
                  ],
                ),
                if (goal.description.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    goal.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                          height: 1.35,
                        ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text('Progress', style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    )),
                    const Spacer(),
                    Text('${(progress * 100).round()}%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textTertiary,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: colors.sageLight,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primaryGreen),
                  ),
                ),
                const SizedBox(height: 14),
                Text('View journey', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textTertiary,
                  fontWeight: FontWeight.w700,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalMeta extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppColorScheme colors;
  final Color? accent;

  const _GoalMeta({
    required this.icon,
    required this.label,
    required this.colors,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final color = accent ?? colors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }
}