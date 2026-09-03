import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String goalId;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime deadline;
  final String category;
  final String description;
  final double overallProgress;
  final String timeCommitment;

  GoalModel({
    required this.goalId,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.deadline,
    required this.category,
    required this.description,
    required this.overallProgress,
    required this.timeCommitment,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      goalId: map['goalId'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      deadline: (map['deadline'] as Timestamp).toDate(),
      category: map['category'] as String,
      description: map['description'] as String,
      overallProgress: (map['overallProgress'] as num).toDouble(),
      timeCommitment: map['timeCommitment'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goalId': goalId,
      'userId': userId,
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'deadline': Timestamp.fromDate(deadline),
      'category': category,
      'description': description,
      'overallProgress': overallProgress,
      'timeCommitment': timeCommitment,
    };
  }

  GoalModel copyWith({
    String? goalId,
    String? userId,
    String? title,
    DateTime? createdAt,
    DateTime? deadline,
    String? category,
    String? description,
    double? overallProgress,
    String? timeCommitment,
  }) {
    return GoalModel(
      goalId: goalId ?? this.goalId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      description: description ?? this.description,
      overallProgress: overallProgress ?? this.overallProgress,
      timeCommitment: timeCommitment ?? this.timeCommitment,
    );
  }
}
