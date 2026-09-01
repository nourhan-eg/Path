import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

/// Renders the grouped Settings card container with 5 tiles.
class ProfileSettingsGroup extends StatelessWidget {
  final VoidCallback onAccountDetailsTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onLanguageTap;
  final VoidCallback onThemeTap;
  final VoidCallback onSignOutTap;
  final String languageText;
  final String themeText;

  const ProfileSettingsGroup({
    super.key,
    required this.onAccountDetailsTap,
    required this.onNotificationsTap,
    required this.onLanguageTap,
    required this.onThemeTap,
    required this.onSignOutTap,
    required this.languageText,
    required this.themeText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            icon: Icons.person_outline_rounded,
            title: 'Account Details',
            onTap: onAccountDetailsTap,
          ),
          _buildDivider(colors),
          _buildSettingsTile(
            context,
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            onTap: onNotificationsTap,
          ),
          _buildDivider(colors),
          _buildSettingsTile(
            context,
            icon: Icons.language_rounded,
            title: 'Language',
            trailingText: languageText,
            onTap: onLanguageTap,
          ),
          _buildDivider(colors),
          _buildSettingsTile(
            context,
            icon: Icons.dark_mode_outlined,
            title: 'Theme',
            trailingText: themeText,
            onTap: onThemeTap,
          ),
          _buildDivider(colors),
          _buildSettingsTile(
            context,
            icon: Icons.logout_rounded,
            title: 'Sign Out',
            titleColor: colors.error,
            iconColor: colors.error,
            showChevron: false,
            onTap: onSignOutTap,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
    Color? titleColor,
    Color? iconColor,
    bool showChevron = true,
  }) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(
        icon,
        color: iconColor ?? colors.textPrimary,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: titleColor ?? colors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
          if (trailingText != null) const SizedBox(width: 6),
          if (showChevron)
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textSecondary,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildDivider(AppColorScheme colors) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: colors.border.withValues(alpha: 0.6),
    );
  }
}
