import 'package:flutter/material.dart';
import 'package:path_app/features/dashboard/screens/dashboard_no_goals.dart';
import 'package:path_app/features/dashboard/screens/dashboard_with_goals.dart';

class DashboardScreen extends StatelessWidget {
  final bool hasGoals;

  const DashboardScreen({
    super.key,
    this.hasGoals = true,
  });

  @override
  Widget build(BuildContext context) {
    if (hasGoals) {
      return const DashboardWithGoals();
    } else {
      return const DashboardNoGoals();
    }
  }
}
