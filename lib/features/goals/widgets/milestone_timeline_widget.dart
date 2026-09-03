import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';
import 'package:path_app/models/milestone_model.dart';

class MilestoneTimelineWidget extends StatelessWidget {
  final List<MilestoneModel> milestones;
  final ValueChanged<MilestoneModel> onMilestoneTap;

  const MilestoneTimelineWidget({
    super.key,
    required this.milestones,
    required this.onMilestoneTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppColorScheme>() ?? AppColorScheme.light;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final completedCount = milestones.where((m) => m.isCompleted).length;
    final currentCount = milestones.where((m) => m.isCurrent).length;
    final currentProgressCount = completedCount + currentCount;
    final totalCount = milestones.length;

    final currentMilestone = milestones.firstWhere(
      (m) => m.isCurrent,
      orElse: () => milestones.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Milestones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? colors.textPrimary : const Color(0xFF2E382B),
              ),
            ),
            Text(
              '$currentProgressCount OF $totalCount',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: isDark
                    ? colors.textSecondary
                    : const Color(0xFF6E786B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        LayoutBuilder(
          builder: (context, constraints) {
            final double circleSize = 34.0;
            final double currentCircleSize = 38.0;

            return Stack(
              alignment: Alignment.topCenter,
              children: [

                Positioned(
                  top: circleSize / 2 - 1,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 2,
                    color: isDark
                        ? const Color(0xFF3B4037)
                        : const Color(0xFFE5E2DA),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: milestones.map((milestone) {
                    return _MilestoneNode(
                      milestone: milestone,
                      circleSize: circleSize,
                      currentCircleSize: currentCircleSize,
                      isDark: isDark,
                      colors: colors,
                      onTap: () => onMilestoneTap(milestone),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            final currentIndex = milestones.indexWhere((m) => m.isCurrent);
            if (currentIndex == -1) return const SizedBox.shrink();

            final int count = milestones.length;
            final double stepPercent = count > 1 ? currentIndex / (count - 1) : 0.5;

            return SizedBox(
              width: double.infinity,
              child: Align(
                alignment: Alignment(stepPercent * 2 - 1, 0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    currentMilestone.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: colors.gold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MilestoneNode extends StatelessWidget {
  final MilestoneModel milestone;
  final double circleSize;
  final double currentCircleSize;
  final bool isDark;
  final AppColorScheme colors;
  final VoidCallback onTap;

  const _MilestoneNode({
    required this.milestone,
    required this.circleSize,
    required this.currentCircleSize,
    required this.isDark,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget childWidget;
    BoxDecoration decoration;

    if (milestone.isCompleted) {

      decoration = BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? const Color(0xFF6B7E68) : const Color(0xFF4A5C48),
      );
      childWidget = const Icon(
        Icons.check_rounded,
        size: 18,
        color: Colors.white,
      );
    } else if (milestone.isCurrent) {

      decoration = BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? const Color(0xFF2A2D27) : const Color(0xFFFAF9F5),
        border: Border.all(
          color: colors.gold,
          width: 3.0,
        ),
      );
      childWidget = Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.gold,
        ),
      );
    } else {
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? const Color(0xFF20231D) : const Color(0xFFFAF9F5),
        border: Border.all(
          color: isDark ? const Color(0xFF3E443A) : const Color(0xFFE4E1D8),
          width: 1.5,
        ),
      );
      childWidget = Icon(
        Icons.lock_outline_rounded,
        size: 14,
        color: isDark ? const Color(0xFF60675D) : const Color(0xFFC7C5BD),
      );
    }

    final double effectiveSize =
        milestone.isCurrent ? currentCircleSize : circleSize;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: effectiveSize,
        height: effectiveSize,
        decoration: decoration,
        alignment: Alignment.center,
        child: childWidget,
      ),
    );
  }
}
