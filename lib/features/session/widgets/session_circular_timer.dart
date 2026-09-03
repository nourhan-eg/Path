import 'package:flutter/material.dart';

/// Circular countdown timer display with progress rings and remaining time text.
class SessionCircularTimer extends StatelessWidget {
  final String formattedTime;
  final double progressRatio;
  final Color primaryColor;
  final Color textSecondary;
  final bool isDark;

  const SessionCircularTimer({
    super.key,
    required this.formattedTime,
    required this.progressRatio,
    required this.primaryColor,
    required this.textSecondary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer background ring
          SizedBox(
            width: 230,
            height: 230,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 8,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? const Color(0xFF3A3C35) : const Color(0xFFE2E7DF),
              ),
            ),
          ),
          // Inner progress ring
          SizedBox(
            width: 230,
            height: 230,
            child: CircularProgressIndicator(
              value: progressRatio,
              strokeWidth: 8,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              strokeCap: StrokeCap.round,
            ),
          ),
          // Center Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formattedTime,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'REMAINING',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
