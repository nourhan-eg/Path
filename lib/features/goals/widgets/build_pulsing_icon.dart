import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

class BuildPulsingIcon extends StatefulWidget {
  final bool isDone;

  const BuildPulsingIcon({super.key, required this.isDone});

  @override
  State<BuildPulsingIcon> createState() => _BuildPulsingIconState();
}

class _BuildPulsingIconState extends State<BuildPulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: widget.isDone
          ? Container(
              key: const ValueKey('done'),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primaryGreen,
                boxShadow: [
                  BoxShadow(
                    color: colors.primaryGreen.withValues(alpha: 0.4),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 42,
              ),
            )
          : AnimatedBuilder(
              key: const ValueKey('pulsing'),
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.gold, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: colors.gold.withValues(alpha: 0.3),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: colors.gold,
                      size: 32,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
