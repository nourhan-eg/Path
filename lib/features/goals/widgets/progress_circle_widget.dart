import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_app/core/theme/app_color.dart';

class ProgressCircleWidget extends StatelessWidget {
  final double percentage; // 0.0 to 1.0 (e.g. 0.65 for 65%)
  final double size;

  const ProgressCircleWidget({
    super.key,
    this.percentage = 0.65,
    this.size = 190.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppColorScheme>() ?? AppColorScheme.light;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final int percentText = (percentage * 100).round();
    final Color strokeColor =
        isDark ? const Color(0xFF7A8D77) : const Color(0xFF4A5C48);
    final Color circleBg =
        isDark ? const Color(0xFF262923) : const Color(0xFFFAF9F5);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleBg,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: percentage,
              strokeColor: strokeColor,
              strokeWidth: 10.0,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percentText%',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: isDark ? colors.textPrimary : const Color(0xFF3B4438),
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'COMPLETED',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: isDark
                      ? colors.textSecondary
                      : const Color(0xFF5A6657),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color strokeColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    final progressPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
