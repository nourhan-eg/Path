import 'package:flutter/material.dart';
import 'package:path_app/models/goal_model.dart';

/// Holds draft data for the goal setup flow across steps.
class GoalProvider extends ChangeNotifier {
  GoalModel? _goal;
  int _currentStep = 1;

  GoalModel? get goal => _goal;
  int get currentStep => _currentStep;

  // Convenience getters for draft goal fields
  String? get goalType => _goal?.category.isNotEmpty == true ? _goal!.category : null;
  String get goalTitle => _goal?.title ?? '';
  String get goalDescription => _goal?.description ?? '';
  String? get timeCommitment => _goal?.timeCommitment.isNotEmpty == true ? _goal!.timeCommitment : null;
  DateTime? get targetDate => _goal?.deadline;

  void updateGoal(GoalModel goal) {
    _goal = goal;
    notifyListeners();
  }

  void updateStep1({
    required String? goalType,
    required String goalTitle,
    required String goalDescription,
    required String? timeCommitment,
    required DateTime? targetDate,
  }) {
    final now = DateTime.now();
    _goal = GoalModel(
      goalId: _goal?.goalId ?? '',
      userId: _goal?.userId ?? '',
      title: goalTitle,
      createdAt: _goal?.createdAt ?? now,
      deadline: targetDate ?? now,
      category: goalType ?? '',
      description: goalDescription,
      overallProgress: _goal?.overallProgress ?? 0.0,
      timeCommitment: timeCommitment ?? '',
    );
    notifyListeners();
  }

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void reset() {
    _goal = null;
    _currentStep = 1;
    notifyListeners();
  }

  void resetDraft() => reset();
}
