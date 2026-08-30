import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activePillColor = isDark ? DarkColors.appBarTitle : LightColors.primaryGreen;
    final activeIconColor = isDark ? const Color(0xFF1B1D19) : Colors.white;
    final inactiveColor = isDark ? DarkColors.textSecondary : LightColors.textSecondary;
    final activeTextColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;

    final items = [
      _NavItem(
        icon: Icons.grid_view_rounded,
        label: 'dashboard.nav_dashboard'.tr(),
      ),
      _NavItem(
        icon: Icons.track_changes_rounded,
        label: 'dashboard.nav_goals'.tr(),
      ),
      _NavItem(
        icon: Icons.alt_route_rounded,
        label: 'dashboard.nav_journey'.tr(),
      ),
      _NavItem(
        icon: Icons.collections_bookmark_outlined,
        label: 'dashboard.nav_resources'.tr(),
      ),
      _NavItem(
        icon: Icons.person_outline_rounded,
        label: 'dashboard.nav_profile'.tr(),
      ),
    ];

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.background : LightColors.background,
        border: Border(
          top: BorderSide(
            color: isDark ? DarkColors.border.withValues(alpha: 0.3) : LightColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;
          final item = items[index];

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSelected
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            color: activePillColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            item.icon,
                            size: 22,
                            color: activeIconColor,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Icon(
                            item.icon,
                            size: 22,
                            color: inactiveColor,
                          ),
                        ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? activeTextColor : inactiveColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
