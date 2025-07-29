import 'package:coliseum/models/user_model.dart';

class DevelopmentAuthService {
  // Simulated user data
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Email/Password Sign Up
  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = User(
      id: 'dev_user_${DateTime.now().millisecondsSinceEpoch}',
      username: email.split('@').first,
      email: email,
      profileImageUrl: 'https://i.pravatar.cc/150?u=${email}',
      bio: 'Usuario de desarrollo',
      postCount: 0,
      followers: 0,
      following: 0,
      firstName: email.split('@').first,
      lastName: '',
      phoneNumber: '',
      dateOfBirth: null,
      authProvider: 'email',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
    
    return _currentUser!;
  }

  // Email/Password Sign In
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate login validation
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    
    _currentUser = User(
      id: 'dev_user_${DateTime.now().millisecondsSinceEpoch}',
      username: email.split('@').first,
      email: email,
      profileImageUrl: 'https://i.pravatar.cc/150?u=${email}',
      bio: 'Usuario de desarrollo',
      postCount: 15,
      followers: 120,
      following: 85,
      firstName: email.split('@').first,
      lastName: 'Usuario',
      phoneNumber: '+1234567890',
      dateOfBirth: DateTime(1990, 1, 1),
      authProvider: 'email',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now(),
    );
    
    return _currentUser!;
  }

  // Google Sign In
  Future<User> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = User(
      id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
      username: 'google_user',
      email: 'google.user@gmail.com',
      profileImageUrl: 'https://i.pravatar.cc/150?u=google',
      bio: 'Usuario de Google',
      postCount: 25,
      followers: 200,
      following: 150,
      firstName: 'Google',
      lastName: 'User',
      phoneNumber: '+1234567890',
      dateOfBirth: DateTime(1985, 5, 15),
      authProvider: 'google',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      lastLoginAt: DateTime.now(),
    );
    
    return _currentUser!;
  }

  // Sign Out
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate sending email
    print('Password reset email sent to: $email');
  }

  // Update Password
  Future<void> updatePassword(String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    if (newPassword.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    print('Password updated successfully');
  }

  // Update Profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        username: displayName ?? _currentUser!.username,
        profileImageUrl: photoURL ?? _currentUser!.profileImageUrl,
      );
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;
} 