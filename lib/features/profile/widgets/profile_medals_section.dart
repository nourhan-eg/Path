import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

/// Renders the Milestone Medals title header and horizontal row of 4 medals.
class ProfileMedalsSection extends StatelessWidget {
  final VoidCallback? onViewAllTap;

  const ProfileMedalsSection({
    super.key,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Milestone Medals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: onViewAllTap ?? () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'VIEW ALL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryGreen,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMedalItem(
              context,
              icon: Icons.star_border_rounded,
              label: 'First Step',
              isUnlocked: true,
              accentColor: colors.gold,
            ),
            _buildMedalItem(
              context,
              icon: Icons.emoji_events_outlined,
              label: '10 Days',
              isUnlocked: true,
              accentColor: colors.primaryGreen,
            ),
            _buildMedalItem(
              context,
              icon: Icons.school_outlined,
              label: 'Learner',
              isUnlocked: true,
              accentColor: colors.primaryGreen,
            ),
            _buildMedalItem(
              context,
              icon: Icons.lock_outline_rounded,
              label: 'Expert',
              isUnlocked: false,
              accentColor: colors.textSecondary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedalItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isUnlocked,
    required Color accentColor,
  }) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked ? accentColor.withValues(alpha: 0.12) : colors.border.withValues(alpha: 0.4),
            border: Border.all(
              color: isUnlocked ? accentColor : colors.border,
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            size: 26,
            color: isUnlocked ? accentColor : colors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w400,
            color: isUnlocked ? colors.textPrimary : colors.textSecondary.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
