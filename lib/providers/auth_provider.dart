import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_app/models/user_model.dart';
import 'package:path_app/services/firebase/auth_service.dart';
import 'package:path_app/services/firebase/firestore_service.dart';

enum AuthStatus { idle, loading, success, error }

/// Manages authentication state, interfacing with [AuthService] and
/// [FirestoreService] for a clean separation of concerns.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthProvider({
    required AuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService;

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  /// Currently signed-in Firebase user, or `null`.
  User? get currentUser => _authService.currentUser;

  /// Whether a user is currently signed in.
  bool get isAuthenticated => currentUser != null;

  /// Stream of auth state changes for reactive listeners.
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  /// Registers a new user, sets display name, creates a Firestore profile,
  /// and sends an email verification link before allowing access.
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      if (credential.user != null) {
        await _authService.sendEmailVerification();
        await _authService.signOut();

        final userModel = UserModel(
          uid: credential.user!.uid,
          email: email,
          name: name,
          joinedAt: DateTime.now(),
          notificationsPreferences: 'all',
        );
        await _firestoreService.createUserDocument(userModel);
      }

      _status = AuthStatus.success;
      _errorMessage = 'Verification email sent. Please verify your email before log in.';
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = AuthService.mapFirebaseAuthError(e);
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  /// Signs in an existing user.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);
      _status = AuthStatus.success;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = AuthService.mapFirebaseAuthError(e);
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  /// Signs out the current user and resets state.
  Future<void> logout() async {
    await _authService.signOut();
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clears the current error, useful when the user dismisses an error dialog.
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.idle;
    }
    notifyListeners();
  }
}
