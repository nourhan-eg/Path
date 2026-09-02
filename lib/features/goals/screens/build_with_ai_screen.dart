import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_color.dart';
import '../../../providers/goal_provider.dart';
import '../widgets/build_pulsing_icon.dart';
import '../widgets/build_step_tile.dart';

class BuildWithAiScreen extends StatefulWidget {
  static const String routeName = '/goals ai';

  const BuildWithAiScreen({super.key});

  @override
  State<BuildWithAiScreen> createState() => _BuildWithAiScreenState();
}

class _BuildWithAiScreenState extends State<BuildWithAiScreen> {
  BuildStep _currentStep = BuildStep.analyzing;
  Timer? _stepTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGeneration();
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  Future<void> _startGeneration() async {
    // Move to "structuring" after a short delay, purely for visual pacing.
    _stepTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _currentStep = BuildStep.structuring);
    });

    final success = await context.read<GoalProvider>().generatePath();
    _stepTimer?.cancel();

    if (!mounted) return;

    if (success) {
      setState(() => _currentStep = BuildStep.finalizing);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      setState(() => _currentStep = BuildStep.done);
      await Future.delayed(const Duration(milliseconds: 1400));
    } else {
      _showError(context.read<GoalProvider>().generationError);
    }
  }

  void _showError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Something went wrong. Please try again.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BuildPulsingIcon(isDone: _currentStep == BuildStep.done),
              const SizedBox(height: 28),
              Text(
                _currentStep == BuildStep.done
                    ? 'Your path is ready!'
                    : 'Building your path...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _currentStep == BuildStep.done
                    ? 'Time to take the first step.'
                    : 'AI is breaking the goal into milestones.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 40),
              BuildStepTile(
                colors: colors,
                label: 'Analyzing input',
                step: BuildStep.analyzing,
                currentStep: _currentStep,
              ),
              const SizedBox(height: 12),
              BuildStepTile(
                colors: colors,
                label: 'Structuring milestones',
                step: BuildStep.structuring,
                currentStep: _currentStep,
              ),
              const SizedBox(height: 12),
              BuildStepTile(
                colors: colors,
                label: 'Finalizing journey',
                step: BuildStep.finalizing,
                currentStep: _currentStep,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
