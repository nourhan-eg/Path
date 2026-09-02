import 'package:cloud_firestore/cloud_firestore.dart';

enum MilestoneStatus { locked, current, completed }

MilestoneStatus _statusFromString(String value) {
  return MilestoneStatus.values.firstWhere(
    (e) => e.name == value,
    orElse: () => MilestoneStatus.locked,
  );
}

/// Model representing a single Milestone in the journey.
class MilestoneModel {
  final String milestoneId;
  final String goalId;
  final String title;
  final String description;
  final int order;
  final DateTime createdAt;
  final double progress;
  final MilestoneStatus status;

  MilestoneModel({
    required this.milestoneId,
    required this.goalId,
    required this.title,
    this.description = '',
    required this.createdAt,
    required this.status,
    required this.order,
    required this.progress,
  });

  bool get isCompleted => status == MilestoneStatus.completed;
  bool get isCurrent => status == MilestoneStatus.current;
  bool get isLocked => status == MilestoneStatus.locked;

  factory MilestoneModel.fromMap(Map<String, dynamic> map) {
    return MilestoneModel(
      milestoneId: map['milestoneId'] as String? ?? '',
      goalId: map['goalId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      status: _statusFromString(map['status'] as String? ?? 'locked'),
      order: map['order'] as int? ?? 1,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'milestoneId': milestoneId,
      'goalId': goalId,
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status.name,
      'order': order,
      'progress': progress,
    };
  }

  MilestoneModel copyWith({
    String? title,
    String? description,
    double? progress,
    MilestoneStatus? status,
  }) {
    return MilestoneModel(
      milestoneId: milestoneId,
      goalId: goalId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      status: status ?? this.status,
      order: order,
      progress: progress ?? this.progress,
    );
  }

  /// Sample dummy data list containing 6 milestones as required.
  static List<MilestoneModel> sampleMilestones() {
    final now = DateTime.now();
    return [
      MilestoneModel(
        milestoneId: 'm1',
        goalId: 'g1',
        title: 'Morning Routine',
        description: 'Establish a solid 30-min morning routine without screens.',
        createdAt: now.subtract(const Duration(days: 20)),
        status: MilestoneStatus.completed,
        order: 1,
        progress: 1.0,
      ),
      MilestoneModel(
        milestoneId: 'm2',
        goalId: 'g1',
        title: 'Deep Work',
        description: 'Practice uninterrupted 90-minute focus blocks daily.',
        createdAt: now.subtract(const Duration(days: 14)),
        status: MilestoneStatus.completed,
        order: 2,
        progress: 1.0,
      ),
      MilestoneModel(
        milestoneId: 'm3',
        goalId: 'g1',
        title: 'Habit Building',
        description: 'Track key habits continuously for 14 consecutive days.',
        createdAt: now.subtract(const Duration(days: 7)),
        status: MilestoneStatus.completed,
        order: 3,
        progress: 1.0,
      ),
      MilestoneModel(
        milestoneId: 'm4',
        goalId: 'g1',
        title: 'Custom Hooks',
        description: 'Implement reusable stateful logic and custom hooks in your workflow.',
        createdAt: now,
        status: MilestoneStatus.current,
        order: 4,
        progress: 0.65,
      ),
      MilestoneModel(
        milestoneId: 'm5',
        goalId: 'g1',
        title: 'Progress Review',
        description: 'Conduct a comprehensive weekly review and adjust your strategy.',
        createdAt: now.add(const Duration(days: 7)),
        status: MilestoneStatus.locked,
        order: 5,
        progress: 0.0,
      ),
      MilestoneModel(
        milestoneId: 'm6',
        goalId: 'g1',
        title: 'Final Reflection',
        description: 'Consolidate learnings, compile evidence, and complete your journey.',
        createdAt: now.add(const Duration(days: 14)),
        status: MilestoneStatus.locked,
        order: 6,
        progress: 0.0,
      ),
    ];
  }
}

// Alias for convenience matching requirement #6
typedef Milestone = MilestoneModel;
