import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isAuthenticated = true;
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Sign In Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Sign In Error: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isAuthenticated = true;
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Sign Up Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Sign Up Error: $e');
      rethrow;
    }
  }

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Create Google auth provider
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      // Sign in with popup/redirect
      final userCredential = await _firebaseAuth.signInWithProvider(
        googleProvider,
      );

      _isAuthenticated = true;
      notifyListeners();

      return userCredential;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return null;
    }
  }

  // Apple Sign-In (iOS only)
  Future<UserCredential?> signInWithApple() async {
    try {
      // This will only work on iOS 13+ and macOS 10.15+
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      debugPrint('Starting Apple Sign-In...');

      // Sign in with Apple
      final userCredential = await _firebaseAuth.signInWithProvider(
        appleProvider,
      );

      debugPrint('Apple Sign-In successful: ${userCredential.user?.uid}');
      _isAuthenticated = true;
      notifyListeners();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException - Code: ${e.code}');
      debugPrint('FirebaseAuthException - Message: ${e.message}');
      debugPrint('FirebaseAuthException - Details: ${e.toString()}');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Apple Sign-In error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        return false;
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to sign in',
        biometricOnly: true,
      );
      if (didAuthenticate) {
        _isAuthenticated = true;
        notifyListeners();
      }
      return didAuthenticate;
    } catch (e) {
      debugPrint('Biometric auth error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }
}
