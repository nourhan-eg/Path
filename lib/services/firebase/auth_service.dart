import 'package:firebase_auth/firebase_auth.dart';

/// Low-level Firebase Authentication wrapper.
///
/// Keeps all Firebase-specific logic in the service layer,
/// exposing clean async methods to the provider.
class AuthService {
  FirebaseAuth? _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth;

  FirebaseAuth get firebaseAuth => _firebaseAuth ??= FirebaseAuth.instance;

  /// Currently signed-in user, or `null`.
  User? get currentUser => firebaseAuth.currentUser;

  /// Stream of auth state changes (sign-in / sign-out).
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  /// Creates a new account and sets the display name.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Set display name on the Firebase user profile.
    await credential.user?.updateDisplayName(name);
    await credential.user?.reload();
    return credential;
  }

  /// Signs in with email and password.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null && !credential.user!.emailVerified) {
      await firebaseAuth.signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email before logging in.',
      );
    }

    return credential;
  }

  /// Sends a verification email to the current authenticated user.
  Future<void> sendEmailVerification() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user is currently signed in.',
      );
    }

    if (user.email == null || user.email!.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'The user email is missing or invalid.',
      );
    }

    await user.sendEmailVerification();
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Maps [FirebaseAuthException] error codes to user-friendly messages.
  static String mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account with this email already exists. Try logging in instead.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password sign-up is not enabled. Please contact support.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please register first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'email-not-verified':
        return 'Please verify your email address before logging in. Check your inbox for the verification link.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
