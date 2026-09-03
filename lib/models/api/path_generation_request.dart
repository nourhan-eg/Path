class PathGenerationRequest {
  final String goalTitle;
  final String goalCategory;
  final double hoursPerDay;
  final DateTime deadline;
  final String description;

  PathGenerationRequest({
    required this.goalTitle,
    required this.goalCategory,
    required this.hoursPerDay,
    required this.deadline,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'goal_title': goalTitle,
      'goal_category': goalCategory.toLowerCase(),
      'time_commitment_hours_per_day': hoursPerDay,
      'deadline': deadline.toIso8601String().split('T').first,
      'description': description,
    };
  }
}
