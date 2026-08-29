class TaskModel {
  final String taskId;
  final String milestoneId;
  final String title;
  final bool isCompleted;
  final int timeSpent;
  final String dueContext;

  TaskModel({
    required this.taskId,
    required this.milestoneId,
    required this.title,
    required this.isCompleted,
    required this.timeSpent,
    required this.dueContext,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'] as String,
      milestoneId: map['milestoneId'] as String,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool,
      timeSpent: map['timeSpent'] as int,
      dueContext: map['dueContext'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'milestoneId': milestoneId,
      'title': title,
      'isCompleted': isCompleted,
      'timeSpent': timeSpent,
      'dueContext': dueContext,
    };
  }

  TaskModel copyWith({bool? isCompleted, int? timeSpent}) {
    return TaskModel(
      taskId: taskId,
      milestoneId: milestoneId,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
      timeSpent: timeSpent ?? this.timeSpent,
      dueContext: dueContext,
    );
  }
}
