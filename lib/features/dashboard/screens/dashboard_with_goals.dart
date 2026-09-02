import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/core/theme/app_color.dart';
import 'package:path_app/features/dashboard/widgets/focus_area_card.dart';
import 'package:path_app/features/dashboard/widgets/greeting_card.dart';
import 'package:path_app/features/dashboard/widgets/today_action_item.dart';

class DashboardWithGoals extends StatefulWidget {
  static const String routeName = '/dashboard_with_goals';

  const DashboardWithGoals({super.key});

  @override
  State<DashboardWithGoals> createState() => _DashboardWithGoalsState();
}

class _DashboardWithGoalsState extends State<DashboardWithGoals> {
  // Interactive dummy state for today's actions
  final List<Map<String, dynamic>> _todayActions = [
    {
      'title': '15 min Guided Meditation',
      'isCompleted': true,
    },
    {
      'title': 'Write 3 pages in journal',
      'isCompleted': false,
    },
    {
      'title': 'Read 10 pages of current book',
      'isCompleted': false,
    },
  ];

  void _toggleTask(int index) {
    setState(() {
      _todayActions[index]['isCompleted'] =
          !_todayActions[index]['isCompleted'];
    });
  }

  void _startTask(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting task: $title'),
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pushNamed(context,AppRouter.sessionRoute );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Greeting Card with 75% Progress Ring
              const GreetingCard(
                userName: 'Alex',
                message: "You're making steady progress on your journey.",
                progressPercent: 0.75,
              ),

              const SizedBox(height: 24),

              // 2. Current Focus Area Section Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF8FA28A)
                            : const Color(0xFF51634E),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.adjust_rounded,
                      size: 14,
                      color: isDark
                          ? const Color(0xFF8FA28A)
                          : const Color(0xFF51634E),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Current Focus Area',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18)
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 3. Focus Area Card
              FocusAreaCard(
                weekText: 'Week 3 of 8',
                title: 'Morning Routine Mastery',
                description:
                    'Establishing a consistent 30-minute meditation and journaling practice before screen time.',
                timeInvested: '12.5 hrs',
                tasksDone: '18 / 24',
                onOptionsPressed: () {
                  // Options menu action
                },
              ),

              const SizedBox(height: 28),

              // 4. Today's Actions Section Header
              Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 22,
                    color: isDark
                        ? const Color(0xFF8FA28A)
                        : const Color(0xFF51634E),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Today's Actions",
                    style:Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18)
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 5. Today's Actions List
              ...List.generate(_todayActions.length, (index) {
                final action = _todayActions[index];
                return TodayActionItem(
                  title: action['title'] as String,
                  isCompleted: action['isCompleted'] as bool,
                  onToggle: (_) => _toggleTask(index),
                  onStartPressed: () => _startTask(action['title'] as String),
                );
              }),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF1B1D19),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.goalsSetRoute);
                  },
                  child: Text(
                    '+ Log New Entry'.tr(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: .w400,
                      color: isDark ? Color(0xff243422) : Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
