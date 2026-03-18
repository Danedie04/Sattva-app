import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Current signed-in user, or null
  static User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in anonymously (no email required — creates a Firebase user silently)
  static Future<User?> signInAnonymously() async {
    try {
      final UserCredential cred = await _auth.signInAnonymously();
      return cred.user;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('[AuthService] signInAnonymously error: ${e.code} — ${e.message}');
      return null;
    }
  }

  /// Sign up with email + password
  static Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw _friendlyError(e.code);
    }
  }

  /// Sign in with email + password
  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw _friendlyError(e.code);
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Convert Firebase error codes to readable messages
  static String _friendlyError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
