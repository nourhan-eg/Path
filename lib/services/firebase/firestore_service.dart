import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_app/models/user_model.dart';

/// Firestore data layer for user documents.
class FirestoreService {
  FirebaseFirestore? _firestore;

  FirestoreService({FirebaseFirestore? firestore}) : _firestore = firestore;

  FirebaseFirestore get firestore => _firestore ??= FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      firestore.collection('users');

  /// Creates a new user document at `users/{uid}`.
  Future<void> createUserDocument(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  /// Reads the user document for the given [uid].
  ///
  /// Returns `null` if the document does not exist.
  Future<UserModel?> getUserDocument(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!);
  }

  /// Updates specific fields on the user document.
  Future<void> updateUserDocument(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _usersCollection.doc(uid).update(data);
  }
}
