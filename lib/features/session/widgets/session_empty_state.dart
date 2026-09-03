import 'package:flutter/material.dart';

/// Widget displayed when no daily tasks are available.
class SessionEmptyState extends StatelessWidget {
  final Color primaryColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onBack;

  const SessionEmptyState({
    super.key,
    required this.primaryColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 64,
              color: primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks available for today',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'All set! You have completed or not yet assigned any daily tasks.',
              textAlign: TextAlign.center,
              style: TextStyle(color: textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: onBack,
              child: const Text(
                'Back to Dashboard',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
