import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../providers/goal_draft_provider.dart';
import '../widgets/goal_date_field.dart';
import '../widgets/goal_type_selector.dart';
import '../widgets/step_indicator.dart';
import '../widgets/time_commitment_grid.dart';

class SetGoalsScreen extends StatefulWidget {
  static const String routeName = '/goals set';

  const SetGoalsScreen({super.key});

  @override
  State<SetGoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<SetGoalsScreen> {
  final TextEditingController _goalTitleController = TextEditingController();
  final TextEditingController _goalDescriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? selectedGoalType;
  String? selectedTimeCommitment;
  DateTime? _selectedDate;
  bool _isLoading = false;

  static const int _maxDescriptionLength = 150;

  final List<Map<String, dynamic>> timeOptions = [
    {'label': '30 min/day', 'icon': Icons.timer_outlined},
    {'label': '1 hr/day', 'icon': Icons.hourglass_bottom},
    {'label': '2+ hrs/day', 'icon': Icons.access_time},
    {'label': 'Flexible', 'icon': Icons.all_inclusive},
  ];

  @override
  void initState() {
    super.initState();
    _goalDescriptionController.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final draft = context.read<GoalDraftProvider>();
      if (draft.goalType != null) {
        setState(() {
          selectedGoalType = draft.goalType;
          _goalTitleController.text = draft.goalType ?? '';
        });
      }
      if (draft.goalDescription.isNotEmpty) {
        _goalDescriptionController.text = draft.goalDescription;
      }
      if (draft.timeCommitment != null) {
        setState(() {
          selectedTimeCommitment = draft.timeCommitment;
        });
      }
      if (draft.targetDate != null) {
        setState(() {
          _selectedDate = draft.targetDate;
          _dateController.text = _formatDate(draft.targetDate!);
        });
      }
    });
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _goalDescriptionController.removeListener(_onTextChanged);
    _goalTitleController.dispose();
    _goalDescriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  bool get _isDateValid {
    if (_selectedDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
    return !targetDay.isBefore(today);
  }

  int get completedFieldsCount {
    int count = 0;
    if (selectedGoalType != null && selectedGoalType!.isNotEmpty) count++;
    if (_goalDescriptionController.text.trim().isNotEmpty) count++;
    if (selectedTimeCommitment != null && selectedTimeCommitment!.isNotEmpty) count++;
    if (_isDateValid) count++;
    return count;
  }

  int get currentStep => completedFieldsCount.clamp(0, 4);

  bool get _isFormValid => completedFieldsCount == 4;

  Future<void> _handleDatePicker() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  Future<void> _handleContinue() async {
    if (!_isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      context.read<GoalDraftProvider>().updateStep1(
        goalType: selectedGoalType,
        goalDescription: _goalDescriptionController.text.trim(),
        timeCommitment: selectedTimeCommitment,
        targetDate: _selectedDate,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;
      Navigator.pushNamed(context, AppRouter.goalsWithAiRoute);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: "PATH"),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'STEP $currentStep OF 4',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StepIndicator(currentStep: currentStep),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Setup Your Goal",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  "Let's define what you're working toward.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: const Color(0xff444841),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "What are you working toward?",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                GoalTypeSelector(
                  selectedType: selectedGoalType,
                  onTypeSelected: (type) {
                    setState(() {
                      selectedGoalType = type;
                      _goalTitleController.text = type;
                    });
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  "Describe your goal",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 3,
                  controller: _goalDescriptionController,
                  maxLength: _maxDescriptionLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.primaryGreen, width: 1.5),
                    ),
                    fillColor: colors.card,
                    filled: true,
                    hintText: 'e.g. Master a new language in 6 months',
                    hintStyle: const TextStyle(color: Color(0xff444841)),
                    counterStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "How much time can you commit?",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                TimeCommitmentGrid(
                  selectedCommitment: selectedTimeCommitment,
                  timeOptions: timeOptions,
                  onCommitmentSelected: (label) {
                    setState(() {
                      selectedTimeCommitment = label;
                    });
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  "When do you want to reach it?",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                GoalDateField(
                  controller: _dateController,
                  selectedDate: _selectedDate,
                  onTap: _handleDatePicker,
                ),
                const SizedBox(height: 24),
                if (!_isFormValid)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Center(
                      child: Text(
                        'Complete all 4 steps above to continue ($completedFieldsCount/4)',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid && !_isLoading ? _handleContinue : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Continue'),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}