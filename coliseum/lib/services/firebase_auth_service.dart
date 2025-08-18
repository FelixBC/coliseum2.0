import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:coliseum/models/user_model.dart';

class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Check if Firebase is available
  Future<bool> isAvailable() async {
    try {
      // Check if Firebase is initialized
      await _auth.authStateChanges().first;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  firebase_auth.User? get currentUser => _auth.currentUser;

  // Get current user as our User model
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      // Convert Firebase User to our User model
      return User(
        id: firebaseUser.uid,
        username: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'user',
        email: firebaseUser.email ?? '',
        profileImageUrl: firebaseUser.photoURL ?? 'https://i.pravatar.cc/150?u=${firebaseUser.uid}',
        bio: '',
        firstName: firebaseUser.displayName?.split(' ').first,
        lastName: (firebaseUser.displayName?.split(' ').length ?? 0) > 1 
            ? firebaseUser.displayName?.split(' ').skip(1).join(' ') 
            : null,
        authProvider: 'firebase',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
    } catch (e) {
      print('Error getting current Firebase user: $e');
      return null;
    }
  }

  // Stream of auth changes
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // Email/Password Sign Up
  Future<firebase_auth.UserCredential> signUpWithEmailAndPassword(String email, String password) async {
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
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword(String email, String password) async {
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

  // Sign in with email and return our User model
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await signInWithEmailAndPassword(email, password);
      final firebaseUser = credential.user;
      if (firebaseUser == null) return null;

      // Convert Firebase User to our User model
      return User(
        id: firebaseUser.uid,
        username: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'user',
        email: firebaseUser.email ?? '',
        profileImageUrl: firebaseUser.photoURL ?? 'https://i.pravatar.cc/150?u=${firebaseUser.uid}',
        bio: '',
        firstName: firebaseUser.displayName?.split(' ').first,
        lastName: (firebaseUser.displayName?.split(' ').length ?? 0) > 1 
            ? firebaseUser.displayName?.split(' ').skip(1).join(' ') 
            : null,
        authProvider: 'firebase',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
    } catch (e) {
      print('Error signing in with email: $e');
      return null;
    }
  }

  // Sign up with email and return our User model
  Future<User?> signUpWithEmail(String email, String password, String username) async {
    try {
      final credential = await signUpWithEmailAndPassword(email, password);
      final firebaseUser = credential.user;
      if (firebaseUser == null) return null;

      // Update display name
      await firebaseUser.updateDisplayName(username);

      // Convert Firebase User to our User model
      return User(
        id: firebaseUser.uid,
        username: username,
        email: firebaseUser.email ?? '',
        profileImageUrl: firebaseUser.photoURL ?? 'https://i.pravatar.cc/150?u=${firebaseUser.uid}',
        bio: '',
        firstName: username.split(' ').first,
        lastName: username.split(' ').length > 1 
            ? username.split(' ').skip(1).join(' ') 
            : null,
        authProvider: 'firebase',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
    } catch (e) {
      print('Error signing up with email: $e');
      return null;
    }
  }

  // Google Sign In
  Future<firebase_auth.UserCredential> signInWithGoogle() async {
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
  User? convertFirebaseUser(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return null;

    return User(
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
  String _getAuthProvider(List<firebase_auth.UserInfo> providerData) {
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
    if (error is firebase_auth.FirebaseAuthException) {
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