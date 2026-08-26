import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final DateTime joinedAt;
  final String notificationsPreferences;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.joinedAt,
    required this.notificationsPreferences,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      joinedAt: (map['joinedAt'] as Timestamp).toDate(),
      notificationsPreferences: map['notificationsPreferences'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'notificationsPreferences': notificationsPreferences,
    };
  }

  UserModel copyWith({String? name, String? notificationsPreferences}) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      joinedAt: joinedAt,
      notificationsPreferences:
          notificationsPreferences ?? this.notificationsPreferences,
    );
  }
}
