import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_app/models/milestone_model.dart';
import 'package:path_app/models/user_model.dart';

import '../../models/goal_model.dart';
import '../../models/task_model.dart';

/// Firestore data layer for user documents.
class FirestoreService {
  FirebaseFirestore? _firestore;

  FirestoreService({FirebaseFirestore? firestore}) : _firestore = firestore;

  FirebaseFirestore get firestore => _firestore ??= FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _goalsCollection =>
      firestore.collection('goals');
  CollectionReference<Map<String, dynamic>> get _milestonesCollection =>
      firestore.collection('milestones');
  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      firestore.collection('tasks');

  /// Creates a new user document at `users/{uid}`.
  Future<void> createUserDocument(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<void> createGoalDocument(GoalModel goal) async {
    await _goalsCollection.doc(goal.goalId).set(goal.toMap());
  }

  Future<void> createMilestonesDocument(MilestoneModel milestones) async {
    await _milestonesCollection
        .doc(milestones.milestoneId)
        .set(milestones.toMap());
  }

  Future<void> createTasksDocument(TaskModel task) async {
    await _tasksCollection.doc(task.taskId).set(task.toMap());
  }

  Future<void> saveGeneratedPath({
    required GoalModel goal,
    required List<MilestoneModel> milestones,
    required List<TaskModel> tasks,
  }) async {
    final batch = firestore.batch();

    batch.set(_goalsCollection.doc(goal.goalId), goal.toMap());
    for (final milestone in milestones) {
      batch.set(
        _milestonesCollection.doc(milestone.milestoneId),
        milestone.toMap(),
      );
    }
    for (final task in tasks) {
      batch.set(_tasksCollection.doc(task.taskId), task.toMap());
    }

    await batch.commit();
  }

  Future<UserModel?> getUserDocument(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<GoalModel?> getGoalDocument(String goalId) async {
    final doc = await _goalsCollection.doc(goalId).get();
    if (!doc.exists || doc.data() == null) return null;
    return GoalModel.fromMap(doc.data()!);
  }

  Future<MilestoneModel?> getMilestonesDocument(String milestoneId) async {
    final doc = await _milestonesCollection.doc(milestoneId).get();
    if (!doc.exists || doc.data() == null) return null;
    return MilestoneModel.fromMap(doc.data()!);
  }

  Future<TaskModel?> getTasksDocument(String taskId) async {
    final doc = await _tasksCollection.doc(taskId).get();
    if (!doc.exists || doc.data() == null) return null;
    return TaskModel.fromMap(doc.data()!);
  }

  /// Updates specific fields on the user document.
  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  Future<List<GoalModel>> getGoalsForUser(String userId) async {
    final snapshot = await _goalsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => GoalModel.fromMap(doc.data())).toList();
  }

  Future<List<MilestoneModel>> getMilestonesForGoal(String goalId) async {
    final snapshot = await _milestonesCollection
        .where('goalId', isEqualTo: goalId)
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => MilestoneModel.fromMap(doc.data()))
        .toList();
  }

  Future<List<TaskModel>> getTasksForMilestone(String milestoneId) async {
    final snapshot = await _tasksCollection
        .where('milestoneId', isEqualTo: milestoneId)
        .orderBy('dueContext')
        .get();

    return snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
  }
}
