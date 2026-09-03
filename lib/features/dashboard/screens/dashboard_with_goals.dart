import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/features/dashboard/screens/dashboard_no_goals.dart';
import 'package:path_app/features/dashboard/widgets/focus_area_card.dart';
import 'package:path_app/features/dashboard/widgets/greeting_card.dart';
import 'package:path_app/features/dashboard/widgets/today_action_item.dart';
import 'package:path_app/providers/auth_provider.dart';
import 'package:path_app/providers/goal_provider.dart';
import 'package:path_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DashboardWithGoals extends StatefulWidget {
  static const String routeName = '/dashboard_with_goals';

  const DashboardWithGoals({super.key});

  @override
  State<DashboardWithGoals> createState() => _DashboardWithGoalsState();
}

class _DashboardWithGoalsState extends State<DashboardWithGoals> {
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        final provider = context.read<GoalProvider>();
        await provider.loadGoals(user.uid);
        if (provider.goals.isNotEmpty) {
          await provider.loadGoalDetails(provider.goals.first.goalId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<GoalProvider>(
      builder: (context, goalProvider, child) {
        if (goalProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (goalProvider.goals.isEmpty) {
          return const DashboardNoGoals();
        }

        final goal = goalProvider.goals.first;
        final userName = context.watch<UserProvider>().displayName;
        final tasks = goalProvider.tasks;
        final completedTasks = tasks.where((task) => task.isCompleted).length;

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
              GreetingCard(
                userName: userName,
                message: "You're making steady progress on your journey.",
                progressPercent: goal.overallProgress,
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.goalDetailsRoute,
                    arguments: goal.goalId,
                  );
                },
                child: FocusAreaCard(
                  title: goal.title,
                  description: goal.description,
                  timeInvested: '0 hrs',
                  tasksDone: '$completedTasks / ${tasks.length}',
                ),
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
              ...List.generate(tasks.length, (index) {
                final task = tasks[index];
                return TodayActionItem(
                  title: task.title,
                  isCompleted: task.isCompleted,
                  onToggle: (_) {},
                  onStartPressed: () => _startTask(task.title),
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
      },
    );
  }
}
