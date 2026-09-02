import 'package:flutter/material.dart';
import 'package:path_app/models/api/path_generation_request.dart';
import 'package:path_app/models/api/path_generation_response.dart';
import 'package:path_app/models/goal_model.dart';
import 'package:path_app/services/ai/path_generation_service.dart';

/// Holds draft data for the goal setup flow across steps.
class GoalProvider extends ChangeNotifier {
  final PathGenerationService _pathGenerationService = PathGenerationService();
  PathGenerationResponse? _generatedPath;
  String? _generationError;
  bool _isGenerating = false;

  PathGenerationResponse? get generatedPath => _generatedPath;
  bool get isGenerating => _isGenerating;
  String? get generationError => _generationError;

  double _hoursFromLabel(String? label) {
    switch (label) {
      case '30 min/day':
        return 0.5;
      case '1 hr/day':
        return 1.0;
      case '2+ hrs/day':
        return 2.0;
      case 'Flexible':
        return 3.0;
      default:
        return 4.0;
    }
  }

  GoalModel? _goal;
  int _currentStep = 1;

  GoalModel? get goal => _goal;
  int get currentStep => _currentStep;

  // Convenience getters for draft goal fields
  String? get goalType =>
      _goal?.category.isNotEmpty == true ? _goal!.category : null;
  String get goalTitle => _goal?.title ?? '';
  String get goalDescription => _goal?.description ?? '';
  String? get timeCommitment =>
      _goal?.timeCommitment.isNotEmpty == true ? _goal!.timeCommitment : null;
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

  Future<bool> generatePath() async {
    if (_goal == null) {
      _generationError = 'Goal data is incomplete.';
      notifyListeners();
      return false;
    }

    _isGenerating = true;
    _generationError = null;
    notifyListeners();

    try {
      final request = PathGenerationRequest(
        goalTitle: _goal!.title,
        goalCategory: _goal!.category,
        hoursPerDay: _hoursFromLabel(_goal!.timeCommitment),
        deadline: _goal!.deadline,
        description: _goal!.description,
      );

      _generatedPath = await _pathGenerationService.generatePath(request);
      _isGenerating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isGenerating = false;
      _generationError = e.toString();
      notifyListeners();
      return false;
    }
  }
}
