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

  Future<void> signIn(String email, String password) async {
    // Mock sign in delay
    await Future.delayed(const Duration(seconds: 2));
    _isAuthenticated = true;
    notifyListeners();
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

      // Sign in with Apple
      final userCredential = await _firebaseAuth.signInWithProvider(
        appleProvider,
      );

      _isAuthenticated = true;
      notifyListeners();

      return userCredential;
    } catch (e) {
      debugPrint('Apple Sign-In error: $e');
      return null;
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
