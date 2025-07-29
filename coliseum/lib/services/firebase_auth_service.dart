import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:coliseum/models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email/Password Sign Up
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Email/Password Sign In
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // For development purposes, we'll simulate a successful login
      // In production, you would use the actual Firebase authentication
      await Future.delayed(const Duration(seconds: 1));
      
      // Create a mock UserCredential for development
      // In production, you would use the actual Firebase credential
      throw Exception('Google Sign-In requires Firebase configuration. Please configure Firebase for production use.');
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Update Password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Update Profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Convert Firebase User to our User Model
  UserModel? convertFirebaseUser(User? firebaseUser) {
    if (firebaseUser == null) return null;

    return UserModel(
      id: firebaseUser.uid,
      username: firebaseUser.displayName ?? 'Usuario',
      email: firebaseUser.email ?? '',
      profileImageUrl: firebaseUser.photoURL ?? '',
      bio: '',
      postCount: 0,
      followers: 0,
      following: 0,
      firstName: firebaseUser.displayName?.split(' ').first ?? '',
      lastName: firebaseUser.displayName?.split(' ').skip(1).join(' ') ?? '',
      phoneNumber: firebaseUser.phoneNumber ?? '',
      dateOfBirth: null,
      authProvider: _getAuthProvider(firebaseUser.providerData),
      createdAt: firebaseUser.metadata.creationTime,
      lastLoginAt: firebaseUser.metadata.lastSignInTime,
    );
  }

  // Get auth provider string
  String _getAuthProvider(List<UserInfo> providerData) {
    if (providerData.isEmpty) return 'email';
    
    final provider = providerData.first.providerId;
    switch (provider) {
      case 'google.com':
        return 'google';
      case 'facebook.com':
        return 'facebook';
      case 'github.com':
        return 'github';
      default:
        return 'email';
    }
  }

  // Handle Firebase Auth errors
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No se encontró una cuenta con este email.';
        case 'wrong-password':
          return 'Contraseña incorrecta.';
        case 'email-already-in-use':
          return 'Este email ya está registrado.';
        case 'weak-password':
          return 'La contraseña es demasiado débil.';
        case 'invalid-email':
          return 'Email inválido.';
        case 'user-disabled':
          return 'Esta cuenta ha sido deshabilitada.';
        case 'too-many-requests':
          return 'Demasiados intentos. Intenta más tarde.';
        case 'operation-not-allowed':
          return 'Esta operación no está permitida.';
        case 'network-request-failed':
          return 'Error de conexión. Verifica tu internet.';
        default:
          return 'Error de autenticación: ${error.message}';
      }
    }
    return error.toString();
  }
} 