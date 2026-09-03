/// Utility helper for Task Session duration calculation and time parsing.
class TaskSessionHelper {
  /// Parses daily hours from user's time commitment string representation.
  /// Examples:
  /// - "30 min/day" -> 0.5
  /// - "1 hr/day" -> 1.0
  /// - "2+ hrs/day" -> 2.0
  /// - "3 hours/day" -> 3.0
  /// - "Flexible" -> 2.0
  static double parseDailyHours(String? timeCommitment) {
    if (timeCommitment == null || timeCommitment.trim().isEmpty) {
      return 2.0; // Default fallback
    }

    final trimmed = timeCommitment.trim().toLowerCase();

    if (trimmed.contains('30 min')) {
      return 0.5;
    }
    if (trimmed.contains('1 hr') || trimmed.contains('1 hour')) {
      return 1.0;
    }
    if (trimmed.contains('2+ hr') || trimmed.contains('2 hr') || trimmed.contains('2 hour')) {
      return 2.0;
    }
    if (trimmed.contains('3 hr') || trimmed.contains('3 hour')) {
      return 3.0;
    }
    if (trimmed.contains('4 hr') || trimmed.contains('4 hour')) {
      return 4.0;
    }

    // Try extracting numbers
    final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(trimmed);
    if (match != null) {
      final parsed = double.tryParse(match.group(1) ?? '');
      if (parsed != null && parsed > 0) {
        return parsed;
      }
    }

    return 2.0; // Default
  }

  /// Calculates per-task duration in minutes based on total daily hours and task count.
  /// Returns duration in minutes (at least 1 minute).
  static int calculatePerTaskMinutes({
    required double dailyHours,
    required int taskCount,
  }) {
    if (taskCount <= 0) {
      return 30; // Default if no tasks
    }
    final totalDailyMinutes = (dailyHours * 60).round();
    if (totalDailyMinutes <= 0) {
      return 15; // Default fallback if 0 hours
    }

    final perTaskMinutes = (totalDailyMinutes / taskCount).round();
    return perTaskMinutes > 0 ? perTaskMinutes : 1;
  }
}
