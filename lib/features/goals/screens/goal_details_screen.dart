import 'package:flutter/material.dart';
import 'package:path_app/core/widgets/custom_app_bar.dart';
import 'package:path_app/features/goals/widgets/goal_progress_body.dart';
import 'package:path_app/providers/goal_provider.dart';
import 'package:provider/provider.dart';

class GoalDetailsScreen extends StatefulWidget {
  static const String routeName = '/goal_details';

  const GoalDetailsScreen({super.key});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final goalId = ModalRoute.of(context)?.settings.arguments as String?;
      if (goalId != null) {
        context.read<GoalProvider>().loadGoalDetails(goalId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalProvider>(
      builder: (context, goalProvider, child) {
        final goal = goalProvider.goal;
        if (goalProvider.isLoading || goal == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final completedTasks = goalProvider.tasks
            .where((task) => task.isCompleted)
            .length;

        return Scaffold(
          appBar: CustomAppBar(title: goal.title),
          body: GoalProgressBody(
            progressPercentage: goal.overallProgress,
            tasksText: '$completedTasks/${goalProvider.tasks.length}',
            milestones: goalProvider.milestones,
          ),
        );
      },
    );
  }
}
