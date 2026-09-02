import 'package:flutter/material.dart';
import 'package:path_app/features/goals/screens/milestone_details_screen.dart';
import 'package:path_app/features/goals/widgets/milestone_timeline_widget.dart';
import 'package:path_app/features/goals/widgets/progress_circle_widget.dart';
import 'package:path_app/features/goals/widgets/statistics_card_widget.dart';
import 'package:path_app/features/goals/widgets/view_journey_button.dart';
import 'package:path_app/models/milestone_model.dart';

class GoalProgressBody extends StatelessWidget {
  final double progressPercentage;
  final String investedText;
  final String tasksText;
  final String evidenceText;
  final List<MilestoneModel>? milestones;
  final VoidCallback? onViewJourneyPressed;

  const GoalProgressBody({
    super.key,
    this.progressPercentage = 0.65,
    this.investedText = '24h',
    this.tasksText = '18/28',
    this.evidenceText = '12',
    this.milestones,
    this.onViewJourneyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final milestoneList = milestones ?? MilestoneModel.sampleMilestones();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProgressCircleWidget(
            percentage: progressPercentage,
            size: 190.0,
          ),

          const SizedBox(height: 28),

          StatisticsCardWidget(
            investedText: investedText,
            tasksText: tasksText,
            evidenceText: evidenceText,
          ),

          const SizedBox(height: 32),

          MilestoneTimelineWidget(
            milestones: milestoneList,
            onMilestoneTap: (milestone) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MilestoneDetailsScreen(milestone: milestone),
                ),
              );
            },
          ),

          const SizedBox(height: 36),

          // 4. View Journey Button
          ViewJourneyButton(
            onPressed: onViewJourneyPressed,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
