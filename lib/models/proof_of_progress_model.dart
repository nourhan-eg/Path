class ProofOfProgress {
  final String id;
  final String userId;
  final String goalId;
  final String milestoneId;
  final String taskId;

  final DateTime sessionStart;
  final DateTime sessionEnd;
  final int actualDurationMinutes;
  final bool completedFullSession;

  final String userNote;
  final String? imageUrl;

  final String? whatWentWell;
  final String? needsAttention;

  final DateTime createdAt;

  ProofOfProgress({
    required this.id,
    required this.userId,
    required this.goalId,
    required this.milestoneId,
    required this.taskId,
    required this.sessionStart,
    required this.sessionEnd,
    required this.actualDurationMinutes,
    required this.completedFullSession,
    required this.userNote,
    this.imageUrl,
    this.whatWentWell,
    this.needsAttention,
    required this.createdAt,
  });

  factory ProofOfProgress.fromJson(Map<String, dynamic> json) {
    return ProofOfProgress(
      id: json['id'] as String,
      userId: json['userId'] as String,
      goalId: json['goalId'] as String,
      milestoneId: json['milestoneId'] as String,
      taskId: json['taskId'] as String,
      sessionStart: DateTime.parse(json['sessionStart'] as String),
      sessionEnd: DateTime.parse(json['sessionEnd'] as String),
      actualDurationMinutes: json['actualDurationMinutes'] as int,
      completedFullSession: json['completedFullSession'] as bool,
      userNote: json['userNote'] as String,
      imageUrl: json['imageUrl'] as String?,
      whatWentWell: json['whatWentWell'] as String?,
      needsAttention: json['needsAttention'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'goalId': goalId,
      'milestoneId': milestoneId,
      'taskId': taskId,
      'sessionStart': sessionStart.toIso8601String(),
      'sessionEnd': sessionEnd.toIso8601String(),
      'actualDurationMinutes': actualDurationMinutes,
      'completedFullSession': completedFullSession,
      'userNote': userNote,
      'imageUrl': imageUrl,
      'whatWentWell': whatWentWell,
      'needsAttention': needsAttention,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}