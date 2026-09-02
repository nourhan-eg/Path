import 'package:flutter/material.dart';
import 'package:path_app/core/widgets/custom_app_bar.dart';
import 'package:path_app/features/goals/widgets/goal_progress_body.dart';

class GoalDetailsScreen extends StatelessWidget {
  static const String routeName = '/goal_details';

  const GoalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Mastering React Hooks'),
      body: const GoalProgressBody(),
    );
  }
}
