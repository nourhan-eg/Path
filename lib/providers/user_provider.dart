import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_app/models/user_model.dart';
import 'package:path_app/services/firebase/firestore_service.dart';

/// Manages the current user's profile data loaded from Firestore.
class UserProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  UserProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasUser => _user != null;

  /// Returns the user's name from Firestore, falling back to Firebase Auth displayName.
  String get displayName {
    if (_user != null && _user!.name.trim().isNotEmpty) {
      return _user!.name;
    }
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser?.displayName != null && firebaseUser!.displayName!.trim().isNotEmpty) {
      return firebaseUser.displayName!;
    }
    return 'User';
  }

  /// Direct setter for the user model.
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// Loads the user profile from Firestore by [uid].
  Future<void> loadUser(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _firestoreService.getUserDocument(uid);
    } catch (_) {
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clears the cached user (e.g. on sign-out).
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
