import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/models/task_model.dart';
import 'package:path_app/providers/goal_provider.dart';
import 'package:path_app/features/session/utils/task_session_helper.dart';
import 'package:path_app/features/session/widgets/session_circular_timer.dart';
import 'package:path_app/features/session/widgets/session_timer_controls.dart';
import 'package:path_app/features/session/widgets/session_ai_checkin_card.dart';
import 'package:path_app/features/session/widgets/session_supporting_evidence.dart';
import 'package:path_app/features/session/widgets/session_empty_state.dart';
import 'package:path_app/features/session/widgets/session_completed_state.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;
  bool _isSubmitting = false;
  int _currentTaskIndex = 0;
  final TextEditingController _aiCheckInController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSession();
    });
  }

  void _initializeSession() {
    final goalProvider = context.read<GoalProvider>();
    final tasks = goalProvider.tasks;

    if (tasks.isEmpty) return;

    final firstUncompleted = tasks.indexWhere((t) => !t.isCompleted);
    if (firstUncompleted != -1) {
      _currentTaskIndex = firstUncompleted;
    } else {
      _currentTaskIndex = 0;
    }

    _setupTimerForCurrentTask();
  }

  void _setupTimerForCurrentTask() {
    _timer?.cancel();
    final goalProvider = context.read<GoalProvider>();
    final goal = goalProvider.goal;
    final tasks = goalProvider.tasks;

    final dailyHours = TaskSessionHelper.parseDailyHours(goal?.timeCommitment);
    final perTaskMinutes = TaskSessionHelper.calculatePerTaskMinutes(
      dailyHours: dailyHours,
      taskCount: tasks.isEmpty ? 1 : tasks.length,
    );

    setState(() {
      _totalSeconds = perTaskMinutes * 60;
      _remainingSeconds = _totalSeconds;
      _isRunning = true;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resumeTimer() {
    if (_remainingSeconds > 0) {
      setState(() {
        _isRunning = true;
      });
      _startTimer();
    }
  }

  void _stopSession() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session paused and saved.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitCurrentTask(TaskModel task) async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    _timer?.cancel();
    final goalProvider = context.read<GoalProvider>();

    try {
      await goalProvider.updateTaskCompletion(task.taskId, true);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${task.title}" completed!'),
          backgroundColor: const Color(0xFF51634E),
          duration: const Duration(seconds: 2),
        ),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(
          context,
          AppRouter.dashboardWishGoalRoute,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit task: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _aiCheckInController.dispose();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? const Color(0xFF8FA28A) : const Color(0xFF51634E);
    final cardBgColor = isDark ? const Color(0xFF2A2C26) : Colors.white;
    final inputBgColor = isDark ? const Color(0xFF1F211C) : const Color(0xFFF4F3EE);
    final textPrimary = isDark ? const Color(0xFFE3E3DE) : const Color(0xFF2C2C2C);
    final textSecondary = isDark ? const Color(0xFFC4C8BF) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Start Session',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: textPrimary),
            onSelected: (value) {
              if (value == 'reset') {
                _setupTimerForCurrentTask();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Text('Reset Timer'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<GoalProvider>(
        builder: (context, goalProvider, child) {
          final tasks = goalProvider.tasks;
          final goal = goalProvider.goal;

          if (goalProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (tasks.isEmpty) {
            return SessionEmptyState(
              primaryColor: primaryColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onBack: () => Navigator.pop(context),
            );
          }

          final allCompleted = tasks.every((t) => t.isCompleted);
          if (allCompleted) {
            return SessionCompletedState(
              primaryColor: primaryColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onReturn: () => Navigator.pop(context),
            );
          }

          if (_currentTaskIndex >= tasks.length) {
            _currentTaskIndex = tasks.indexWhere((t) => !t.isCompleted);
            if (_currentTaskIndex == -1) _currentTaskIndex = 0;
          }

          final currentTask = tasks[_currentTaskIndex];
          final dailyHours = TaskSessionHelper.parseDailyHours(goal?.timeCommitment);
          final perTaskMinutes = TaskSessionHelper.calculatePerTaskMinutes(
            dailyHours: dailyHours,
            taskCount: tasks.length,
          );

          final progressRatio = _totalSeconds > 0
              ? (_remainingSeconds / _totalSeconds).clamp(0.0, 1.0)
              : 0.0;

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$perTaskMinutes-min ${currentTask.title}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: currentTask.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Circular Timer Component
                  SessionCircularTimer(
                    formattedTime: _formatTime(_remainingSeconds),
                    progressRatio: progressRatio,
                    primaryColor: primaryColor,
                    textSecondary: textSecondary,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 24),

                  // Control Buttons (Pause / Resume and Stop)
                  SessionTimerControls(
                    isRunning: _isRunning,
                    onPauseResume: _isRunning ? _pauseTimer : _resumeTimer,
                    onStop: _stopSession,
                    primaryColor: primaryColor,
                    cardBgColor: cardBgColor,
                  ),

                  const SizedBox(height: 28),

                  // AI Check-in Component
                  SessionAiCheckInCard(
                    controller: _aiCheckInController,
                    primaryColor: primaryColor,
                    cardBgColor: cardBgColor,
                    inputBgColor: inputBgColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 24),

                  // Supporting Evidence Component
                  SessionSupportingEvidence(
                    primaryColor: primaryColor,
                    cardBgColor: cardBgColor,
                    textPrimary: textPrimary,
                    isDark: isDark,
                    onUploadPhoto: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Upload Photo selected'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    onUploadPdf: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Upload PDF selected'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // Submit Task Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: _isSubmitting || currentTask.isCompleted
                          ? null
                          : () => _submitCurrentTask(currentTask),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              currentTask.isCompleted
                                  ? 'Task Completed'
                                  : 'Submit Task',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
