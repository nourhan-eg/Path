import 'package:path_app/models/api/api_task.dart';

class ApiMilestone {
  final String id;
  final String pathId;
  final String title;
  final String description;
  final int order;
  final String targetDate;
  final List<ApiTask> tasks;

  ApiMilestone({
    required this.id,
    required this.pathId,
    required this.title,
    required this.description,
    required this.order,
    required this.targetDate,
    required this.tasks,
  });

  factory ApiMilestone.fromJson(Map<String, dynamic> json) {
    return ApiMilestone(
      id: json['id'] as String,
      pathId: json['path_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
      targetDate: json['target_date'] as String,
      tasks: (json['tasks'] as List)
          .map((t) => ApiTask.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}
