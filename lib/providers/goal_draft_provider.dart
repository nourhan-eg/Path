import 'package:flutter/material.dart';

/// Holds draft data for the goal setup flow across steps.
class GoalDraftProvider extends ChangeNotifier {
  String? _goalType;
  String _goalDescription = '';
  String? _timeCommitment;
  DateTime? _targetDate;
  int _currentStep = 1;

  String? get goalType => _goalType;
  String get goalDescription => _goalDescription;
  String? get timeCommitment => _timeCommitment;
  DateTime? get targetDate => _targetDate;
  int get currentStep => _currentStep;

  void updateStep1({
    required String? goalType,
    required String goalDescription,
    required String? timeCommitment,
    required DateTime? targetDate,
  }) {
    _goalType = goalType;
    _goalDescription = goalDescription;
    _timeCommitment = timeCommitment;
    _targetDate = targetDate;
    notifyListeners();
  }

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void reset() {
    _goalType = null;
    _goalDescription = '';
    _timeCommitment = null;
    _targetDate = null;
    _currentStep = 1;
    notifyListeners();
  }
}
