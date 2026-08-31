import 'package:flutter/material.dart';
import '../models/goal_model.dart';


class GoalProvider extends ChangeNotifier {

  String? _selectedGoalType;
  String _goalDescription = '';
  String? _selectedTimeCommitment;
  DateTime? _targetDate;
  int _currentStep = 1;

  List<GoalModel> _goals = [];
  bool _isLoading = false;

  String? get selectedGoalType => _selectedGoalType;
  String get goalDescription => _goalDescription;
  String? get selectedTimeCommitment => _selectedTimeCommitment;
  DateTime? get targetDate => _targetDate;
  int get currentStep => _currentStep;

  List<GoalModel> get goals => _goals;
  bool get isLoading => _isLoading;


  int get completedFieldsCount {
    int count = 0;
    if (_selectedGoalType != null && _selectedGoalType!.isNotEmpty) count++;
    if (_goalDescription.trim().isNotEmpty) count++;
    if (_selectedTimeCommitment != null && _selectedTimeCommitment!.isNotEmpty) count++;
    if (_targetDate != null) count++;
    return count;
  }

  void updateDraftStep1({
    required String? goalType,
    required String goalDescription,
    required String? timeCommitment,
    required DateTime? targetDate,
  }) {
    _selectedGoalType = goalType;
    _goalDescription = goalDescription;
    _selectedTimeCommitment = timeCommitment;
    _targetDate = targetDate;
    notifyListeners();
  }

  void setGoalType(String? type) {
    _selectedGoalType = type;
    notifyListeners();
  }

  void setGoalDescription(String description) {
    _goalDescription = description;
    notifyListeners();
  }

  void setTimeCommitment(String? commitment) {
    _selectedTimeCommitment = commitment;
    notifyListeners();
  }

  void setTargetDate(DateTime? date) {
    _targetDate = date;
    notifyListeners();
  }

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void resetDraft() {
    _selectedGoalType = null;
    _goalDescription = '';
    _selectedTimeCommitment = null;
    _targetDate = null;
    _currentStep = 1;
    notifyListeners();
  }
}
