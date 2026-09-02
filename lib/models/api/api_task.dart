class ApiTask {
  final String id;
  final String milestoneId;
  final String title;
  final String description;
  final int estimatedMinutes;
  final int order;
  final String status;

  ApiTask({
    required this.id,
    required this.milestoneId,
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    required this.order,
    required this.status,
  });

  factory ApiTask.fromJson(Map<String, dynamic> json) {
    return ApiTask(
      id: json['id'] as String,
      milestoneId: json['milestone_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      estimatedMinutes: json['estimated_minutes'] as int,
      order: json['order'] as int,
      status: json['status'] as String,
    );
  }
}
