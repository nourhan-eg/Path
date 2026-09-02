import 'package:path_app/models/api/api_milestone.dart';

class PathGenerationResponse {
  final String id;
  final String goalTitle;
  final String goalCategory;
  final String deadline;
  final String summary;
  final List<ApiMilestone> milestones;

  PathGenerationResponse({
    required this.id,
    required this.goalTitle,
    required this.goalCategory,
    required this.deadline,
    required this.summary,
    required this.milestones,
  });

  factory PathGenerationResponse.fromJson(Map<String, dynamic> json) {
    return PathGenerationResponse(
      id: json['id'] as String,
      goalTitle: json['goal_title'] as String,
      goalCategory: json['goal_category'] as String,
      deadline: json['deadline'] as String,
      summary: json['summary'] as String,
      milestones: (json['milestones'] as List)
          .map((m) => ApiMilestone.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
