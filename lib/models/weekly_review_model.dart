class WeeklyReview {
  final String id;
  final String userId;
  final String? goalId;

  final DateTime weekStart;
  final DateTime weekEnd;


  final int daysActive;
  final int totalDaysInWeek;
  final double hoursFocused;
  final int tasksDone;
  final int milestonesCompleted;


  final List<String> whatWentWell;
  final List<String> needsAttention;
  final String? suggestedFocus;
  final String? suggestedFocusReason;

  final bool addedToNextWeek;

  final DateTime createdAt;

  WeeklyReview({
    required this.id,
    required this.userId,
    this.goalId,
    required this.weekStart,
    required this.weekEnd,
    required this.daysActive,
    required this.totalDaysInWeek,
    required this.hoursFocused,
    required this.tasksDone,
    required this.milestonesCompleted,
    this.whatWentWell = const [],
    this.needsAttention = const [],
    this.suggestedFocus,
    this.suggestedFocusReason,
    this.addedToNextWeek = false,
    required this.createdAt,
  });

  factory WeeklyReview.fromJson(Map<String, dynamic> json) {
    return WeeklyReview(
      id: json['id'] as String,
      userId: json['userId'] as String,
      goalId: json['goalId'] as String?,
      weekStart: DateTime.parse(json['weekStart'] as String),
      weekEnd: DateTime.parse(json['weekEnd'] as String),
      daysActive: json['daysActive'] as int,
      totalDaysInWeek: json['totalDaysInWeek'] as int,
      hoursFocused: (json['hoursFocused'] as num).toDouble(),
      tasksDone: json['tasksDone'] as int,
      milestonesCompleted: json['milestonesCompleted'] as int,
      whatWentWell: (json['whatWentWell'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          const [],
      needsAttention: (json['needsAttention'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          const [],
      suggestedFocus: json['suggestedFocus'] as String?,
      suggestedFocusReason: json['suggestedFocusReason'] as String?,
      addedToNextWeek: json['addedToNextWeek'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'goalId': goalId,
      'weekStart': weekStart.toIso8601String(),
      'weekEnd': weekEnd.toIso8601String(),
      'daysActive': daysActive,
      'totalDaysInWeek': totalDaysInWeek,
      'hoursFocused': hoursFocused,
      'tasksDone': tasksDone,
      'milestonesCompleted': milestonesCompleted,
      'whatWentWell': whatWentWell,
      'needsAttention': needsAttention,
      'suggestedFocus': suggestedFocus,
      'suggestedFocusReason': suggestedFocusReason,
      'addedToNextWeek': addedToNextWeek,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}