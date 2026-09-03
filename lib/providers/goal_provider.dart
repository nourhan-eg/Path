import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_app/models/api/api_milestone.dart';
import 'package:path_app/models/api/api_task.dart';
import 'package:path_app/models/api/path_generation_request.dart';
import 'package:path_app/models/api/path_generation_response.dart';
import 'package:path_app/models/goal_model.dart';
import 'package:path_app/models/milestone_model.dart';
import 'package:path_app/models/task_model.dart';
import 'package:path_app/services/ai/path_generation_service.dart';
import 'package:path_app/services/firebase/firestore_service.dart';

/// Holds draft data for the goal setup flow across steps.
class GoalProvider extends ChangeNotifier {
  final PathGenerationService _pathGenerationService = PathGenerationService();
  final FirestoreService _firestoreService;

  GoalProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  PathGenerationResponse? _generatedPath;
  String? _generationError;
  bool _isGenerating = false;
  bool _isLoading = false;
  String? _loadError;
  List<GoalModel> _goals = [];
  List<MilestoneModel> _milestones = [];
  List<TaskModel> _tasks = [];

  PathGenerationResponse? get generatedPath => _generatedPath;
  bool get isGenerating => _isGenerating;
  String? get generationError => _generationError;
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;
  List<GoalModel> get goals => List.unmodifiable(_goals);
  List<MilestoneModel> get milestones => List.unmodifiable(_milestones);
  List<TaskModel> get tasks => List.unmodifiable(_tasks);

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

  Future<void> loadGoals(String userId) async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      _goals = await _firestoreService.getGoalsForUser(userId);
    } catch (error) {
      _loadError = error.toString();
      _goals = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserGoals(String userId) async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      _goals = await _firestoreService.getGoalsForUser(userId);
      _milestones = [];
      _tasks = [];

      if (_goals.isNotEmpty) {
        final firstGoal = _goals.first;
        _goal = firstGoal;
        _milestones = await _firestoreService.getMilestonesForGoal(
          firstGoal.goalId,
        );

        final taskLists = await Future.wait(
          _milestones.map(
            (milestone) => _firestoreService.getTasksForMilestone(
              milestone.milestoneId,
            ),
          ),
        );
        _tasks = taskLists.expand((tasks) => tasks).toList();
      }
    } catch (error) {
      _loadError = error.toString();
      _goals = [];
      _milestones = [];
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadGoalDetails(String goalId) async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      final goal = await _firestoreService.getGoalDocument(goalId);
      _milestones = await _firestoreService.getMilestonesForGoal(goalId);

      final taskLists = await Future.wait(
        _milestones.map(
          (milestone) => _firestoreService.getTasksForMilestone(
            milestone.milestoneId,
          ),
        ),
      );
      _tasks = taskLists.expand((tasks) => tasks).toList();

      if (goal != null) {
        _goal = goal;
        _goals = [
          ..._goals.where((existing) => existing.goalId != goal.goalId),
          goal,
        ];
      }
    } catch (error) {
      _loadError = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    final taskIndex = _tasks.indexWhere((task) => task.taskId == taskId);
    if (taskIndex == -1) return;

    final previousTask = _tasks[taskIndex];
    _tasks[taskIndex] = previousTask.copyWith(isCompleted: isCompleted);
    notifyListeners();

    try {
      await _firestoreService.updateTaskCompletion(taskId, isCompleted);

      final totalTasks = _tasks.length;
      final completedTasks =
          _tasks.where((task) => task.isCompleted).length;
      final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
      final currentGoal = _goal;
      if (currentGoal != null) {
        final updatedGoal = currentGoal.copyWith(overallProgress: progress);
        _goal = updatedGoal;
        _goals = _goals
            .map(
              (goal) => goal.goalId == updatedGoal.goalId ? updatedGoal : goal,
            )
            .toList();
        await _firestoreService.updateGoalProgress(
          currentGoal.goalId,
          progress,
        );
        notifyListeners();
      }
    } catch (error) {
      _tasks[taskIndex] = previousTask;
      _loadError = error.toString();
      notifyListeners();
    }
  }

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
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw StateError('You must be logged in to save a goal.');
      }

      final goal = _toGoalModel(_generatedPath!, user.uid);
      final milestones = _generatedPath!.milestones
          .map((milestone) => _toMilestoneModel(milestone, goal.goalId))
          .toList();
      final tasks = [
        for (final milestone in _generatedPath!.milestones)
          for (final task in milestone.tasks) _toTaskModel(task, milestone.id),
      ];

      await _firestoreService.saveGeneratedPath(
        goal: goal,
        milestones: milestones,
        tasks: tasks,
      );
      _goal = goal;
      _goals = [goal, ..._goals.where((item) => item.goalId != goal.goalId)];
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

  GoalModel _toGoalModel(PathGenerationResponse response, String userId) {
    return GoalModel(
      goalId: response.id,
      userId: userId,
      title: response.goalTitle,
      createdAt: DateTime.now(),
      deadline: DateTime.tryParse(response.deadline) ?? DateTime.now(),
      category: response.goalCategory,
      description: response.summary,
      overallProgress: 0.0,
      timeCommitment: _goal?.timeCommitment ?? '',
    );
  }

  MilestoneModel _toMilestoneModel(ApiMilestone milestone, String goalId) {
    return MilestoneModel(
      milestoneId: milestone.id,
      goalId: goalId,
      title: milestone.title,
      description: milestone.description,
      order: milestone.order,
      createdAt: DateTime.tryParse(milestone.targetDate) ?? DateTime.now(),
      progress: 0.0,
      status: MilestoneStatus.locked,
    );
  }

  TaskModel _toTaskModel(ApiTask task, String milestoneId) {
    return TaskModel(
      taskId: task.id,
      milestoneId: milestoneId,
      title: task.title,
      isCompleted: task.status.toLowerCase() == 'completed',
      timeSpent: 0,
      dueContext: task.description,
    );
  }
}
