import 'package:flutter/material.dart';

/// Control buttons (Pause / Resume and Stop) for the task session timer.
class SessionTimerControls extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onPauseResume;
  final VoidCallback onStop;
  final Color primaryColor;
  final Color cardBgColor;

  const SessionTimerControls({
    super.key,
    required this.isRunning,
    required this.onPauseResume,
    required this.onStop,
    required this.primaryColor,
    required this.cardBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pause / Resume Button
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: primaryColor, width: 1.5),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            backgroundColor: cardBgColor,
          ),
          onPressed: onPauseResume,
          icon: Icon(
            isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: primaryColor,
            size: 20,
          ),
          label: Text(
            isRunning ? 'Pause' : 'Resume',
            style: TextStyle(
              color: primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Stop Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC02626),
            elevation: 0,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
          onPressed: onStop,
          icon: const Icon(
            Icons.crop_square_rounded,
            color: Colors.white,
            size: 18,
          ),
          label: const Text(
            'Stop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
