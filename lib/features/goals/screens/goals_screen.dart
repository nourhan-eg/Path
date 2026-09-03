import 'package:flutter/material.dart';
import 'package:path_app/core/widgets/custom_app_bar.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/features/goals/widgets/goal_card.dart';
import 'package:path_app/providers/auth_provider.dart';
import 'package:path_app/providers/goal_provider.dart';
import 'package:provider/provider.dart';

class GoalsScreen extends StatefulWidget {
  static const String routeName = '/goals';
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<GoalProvider>().loadUserGoals(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Your goals'),
      body: Consumer<GoalProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.goals.isEmpty) {
            if (provider.loadError != null) {
              return Center(child: Text(provider.loadError!));
            }
            return const Center(child: Text('No goals yet.'));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Text(
                '${provider.goals.length} ${provider.goals.length == 1 ? 'goal' : 'goals'} in progress',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...provider.goals.map(
                (goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GoalCard(
                    goal: goal,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.goalDetailsRoute,
                        arguments: goal.goalId,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.goalsSetRoute);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Set another goal'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
