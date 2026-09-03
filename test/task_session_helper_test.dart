import 'package:flutter_test/flutter_test.dart';
import 'package:path_app/features/session/utils/task_session_helper.dart';

void main() {
  group('TaskSessionHelper', () {
    test('parseDailyHours parses correctly', () {
      expect(TaskSessionHelper.parseDailyHours('30 min/day'), 0.5);
      expect(TaskSessionHelper.parseDailyHours('1 hr/day'), 1.0);
      expect(TaskSessionHelper.parseDailyHours('2+ hrs/day'), 2.0);
      expect(TaskSessionHelper.parseDailyHours('3 hours/day'), 3.0);
      expect(TaskSessionHelper.parseDailyHours('4 hours'), 4.0);
      expect(TaskSessionHelper.parseDailyHours('Flexible'), 2.0);
      expect(TaskSessionHelper.parseDailyHours(null), 2.0);
    });

    test('calculatePerTaskMinutes divides daily time equally among tasks', () {
      // 2 hours (120 mins) with 4 tasks => 30 mins each
      expect(
        TaskSessionHelper.calculatePerTaskMinutes(
          dailyHours: 2.0,
          taskCount: 4,
        ),
        30,
      );

      // 3 hours (180 mins) with 6 tasks => 30 mins each
      expect(
        TaskSessionHelper.calculatePerTaskMinutes(
          dailyHours: 3.0,
          taskCount: 6,
        ),
        30,
      );

      // 1 hour (60 mins) with 2 tasks => 30 mins each
      expect(
        TaskSessionHelper.calculatePerTaskMinutes(
          dailyHours: 1.0,
          taskCount: 2,
        ),
        30,
      );

      // Edge case: 0 tasks fallback
      expect(
        TaskSessionHelper.calculatePerTaskMinutes(
          dailyHours: 2.0,
          taskCount: 0,
        ),
        30,
      );

      // Edge case: 0 hours fallback
      expect(
        TaskSessionHelper.calculatePerTaskMinutes(
          dailyHours: 0.0,
          taskCount: 4,
        ),
        15,
      );
    });
  });
}
