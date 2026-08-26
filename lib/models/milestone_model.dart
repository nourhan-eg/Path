import 'package:cloud_firestore/cloud_firestore.dart';

enum MilestoneStatus { locked, current, completed }

MilestoneStatus _statusFromString(String value) {
  return MilestoneStatus.values.firstWhere(
    (e) => e.name == value,
    orElse: () => MilestoneStatus.locked,
  );
}

class MilestoneModel {
  final String milestoneId;
  final String goalId;
  final String title;
  final int order;
  final DateTime createdAt;
  final double progress;
  final MilestoneStatus status;

  MilestoneModel({
    required this.milestoneId,
    required this.goalId,
    required this.title,
    required this.createdAt,
    required this.status,
    required this.order,
    required this.progress,
  });

  factory MilestoneModel.fromMap(Map<String, dynamic> map) {
    return MilestoneModel(
      milestoneId: map['milestoneId'] as String,
      goalId: map['goalId'] as String,
      title: map['title'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: _statusFromString(map['status'] as String),
      order: map['order'] as int,
      progress: (map['progress'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'milestoneId': milestoneId,
      'goalId': goalId,
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status.name,
      'order': order,
      'progress': progress,
    };
  }

  MilestoneModel copyWith({double? progress, MilestoneStatus? status}) {
    return MilestoneModel(
      milestoneId: milestoneId,
      goalId: goalId,
      title: title,
      createdAt: createdAt,
      status: status ?? this.status,
      order: order,
      progress: progress ?? this.progress,
    );
  }
}
