import 'package:flutter/material.dart';

/// Widget displayed when all tasks for the day are completed.
class SessionCompletedState extends StatelessWidget {
  final Color primaryColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onReturn;

  const SessionCompletedState({
    super.key,
    required this.primaryColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 72,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'All Tasks Completed!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Great job! You have finished all assigned tasks for today.',
              textAlign: TextAlign.center,
              style: TextStyle(color: textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: const StadiumBorder(),
                ),
                onPressed: onReturn,
                child: const Text(
                  'Return to Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
