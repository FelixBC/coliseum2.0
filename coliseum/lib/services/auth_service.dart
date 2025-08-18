import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/google_auth_service.dart';
import 'package:coliseum/services/firebase_auth_service.dart';
import 'package:coliseum/services/development_auth_service.dart';
import 'package:coliseum/services/storage_service.dart';
import 'package:coliseum/services/session_service.dart';
import 'package:coliseum/services/biometric_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthService extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _errorMessage;
  
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final DevelopmentAuthService _developmentAuthService = DevelopmentAuthService();
  final SessionService _sessionService = SessionService();
  final BiometricService _biometricService = BiometricService();

  // Getters
  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isSessionValid => _sessionService.isSessionValid;
  bool get isSessionExpiringSoon => _sessionService.isSessionExpiringSoon;
  Duration? get remainingSessionTime => _sessionService.remainingSessionTime;

  AuthService() {
    _initializeAuth();
  }

  @override
  void dispose() {
    _sessionService.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    _currentUser = _sessionService.currentUser;
    _status = _sessionService.isSessionValid 
        ? AuthStatus.authenticated 
        : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> _initializeAuth() async {
    try {
      _setStatus(AuthStatus.loading);
      
      // Initialize storage service
      await StorageService.initialize();
      
      // Listen to session changes
      _sessionService.addListener(_onSessionChanged);
      
      // Check if user is already authenticated locally
      final hasValidData = await StorageService.hasValidUserData();
      if (hasValidData) {
        final storedUser = await StorageService.getUser();
        if (storedUser != null) {
          _currentUser = storedUser;
          _setStatus(AuthStatus.authenticated);
          print('User restored from local storage: ${storedUser.email}');
          return;
        }
      }
      
      // Check if user is already signed in with Google
      final googleUser = await _googleAuthService.getCurrentUser();
      if (googleUser != null) {
        await _handleGoogleSignIn();
        return;
      }

      // Check Firebase auth if available
      if (await _firebaseAuthService.isAvailable()) {
        final firebaseUser = await _firebaseAuthService.getCurrentUser();
        if (firebaseUser != null) {
          _currentUser = firebaseUser;
          await _storeUserData(firebaseUser);
          _setStatus(AuthStatus.authenticated);
          return;
        }
      }

      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _setError('Error initializing authentication: $e');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      _setStatus(AuthStatus.loading);
      _clearError();
      
      final user = await _googleAuthService.signInWithGoogle();
      if (user != null) {
        await _handleGoogleSignIn();
        return user;
      } else {
        _setStatus(AuthStatus.unauthenticated);
        return null;
      }
    } catch (e) {
      _setError('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      // Get additional profile information
      final additionalInfo = await _googleAuthService.getAdditionalProfileInfo();
      
      // Update current user with additional info
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          lastLoginAt: DateTime.now(),
          // You can add more fields from additionalInfo here
        );
      }

      // Store user data locally and create session
      await _storeUserData(_currentUser!);
      await _sessionService.createSession(_currentUser!);
      
      _setStatus(AuthStatus.authenticated);
    } catch (e) {
      _setError('Error handling Google sign-in: $e');
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      _setStatus(AuthStatus.loading);
      _clearError();
      
      // Check if this is a test account
      if (email.contains('test.coliseum') || email.contains('test@coliseum')) {
        print('Using development auth service for test account: $email');
        final user = await _developmentAuthService.signInWithEmail(email, password);
        if (user != null) {
          _currentUser = user;
          await _sessionService.createSession(user);
          _setStatus(AuthStatus.authenticated);
          print('User signed in with development service: ${user.email}');
          return user;
        } else {
          _setError('Invalid test credentials');
          _setStatus(AuthStatus.unauthenticated);
          return null;
        }
      }
      
      // For real accounts, try Firebase first, then fallback to development
      try {
        print('Attempting Firebase authentication for: $email');
        final user = await _firebaseAuthService.signInWithEmail(email, password);
        if (user != null) {
          _currentUser = user;
          await _sessionService.createSession(user);
          _setStatus(AuthStatus.authenticated);
          print('User signed in with Firebase: ${user.email}');
          return user;
        }
      } catch (firebaseError) {
        print('Firebase authentication failed: $firebaseError');
        // Fallback to development service for real accounts if Firebase fails
        try {
          print('Falling back to development auth service for: $email');
          final user = await _developmentAuthService.signInWithEmail(email, password);
          if (user != null) {
            _currentUser = user;
            await _sessionService.createSession(user);
            _setStatus(AuthStatus.authenticated);
            print('User signed in with development service (fallback): ${user.email}');
            return user;
          }
        } catch (devError) {
          print('Development service fallback also failed: $devError');
        }
      }
      
      _setError('Invalid credentials');
      _setStatus(AuthStatus.unauthenticated);
      return null;
    } catch (e) {
      _setError('Error signing in: $e');
      _setStatus(AuthStatus.unauthenticated);
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email, String password, String username) async {
    try {
      _setStatus(AuthStatus.loading);
      _clearError();
      
      User? user;
      if (await _firebaseAuthService.isAvailable()) {
        user = await _firebaseAuthService.signUpWithEmail(email, password, username);
      } else {
        user = await _developmentAuthService.signUpWithEmail(email, password, username);
      }
      
      if (user != null) {
        _currentUser = user;
        await _storeUserData(user);
        await _sessionService.createSession(user);
        _setStatus(AuthStatus.authenticated);
        return user;
      } else {
        _setStatus(AuthStatus.unauthenticated);
        return null;
      }
    } catch (e) {
      _setError('Error signing up with email: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      _setStatus(AuthStatus.loading);
      
      // Sign out from all services
      await _googleAuthService.signOut();
      if (await _firebaseAuthService.isAvailable()) {
        await _firebaseAuthService.signOut();
      }
      await _developmentAuthService.signOut();
      
      // Clear session and local user data
      await _sessionService.logout();
      _currentUser = null;
      await _clearUserData();
      
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _setError('Error signing out: $e');
    }
  }

  Future<void> updateProfile(User updatedUser) async {
    try {
      _currentUser = updatedUser;
      await _storeUserData(updatedUser);
      await _sessionService.extendSession();
      notifyListeners();
    } catch (e) {
      _setError('Error updating profile: $e');
    }
  }

  Future<void> _storeUserData(User user) async {
    try {
      // Store user data locally
      final success = await StorageService.saveUser(user);
      if (success) {
        print('User data stored locally: ${user.email}');
      } else {
        print('Failed to store user data locally');
      }
      
      // If you have an auth token, store it too
      if (user.authProvider == 'google') {
        // For Google, you might want to store the ID token
        // This would come from the GoogleSignInAuthentication
      }
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  Future<void> _clearUserData() async {
    try {
      await StorageService.clearAllData();
      print('All user data cleared from local storage');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  // Session management methods
  Future<void> extendSession() async {
    await _sessionService.extendSession();
  }

  Future<void> refreshSession() async {
    await _sessionService.forceRefresh();
  }

  void updateActivity() {
    _sessionService.updateActivity();
  }

  bool validateSession() {
    return _sessionService.validateSession();
  }

  // Check if user has valid local data
  Future<bool> hasValidLocalData() async {
    return await StorageService.hasValidUserData();
  }

  // Get last login time
  Future<DateTime?> getLastLogin() async {
    return await StorageService.getLastLogin();
  }

  // Get authentication provider
  Future<String?> getAuthProvider() async {
    return await StorageService.getAuthProvider();
  }

  // Get storage statistics for debugging
  Future<Map<String, dynamic>> getStorageStats() async {
    return await StorageService.getStorageStats();
  }

  // Get session information
  Map<String, dynamic> getSessionInfo() {
    return _sessionService.getSessionInfo();
  }

  // Refresh user data from local storage
  Future<void> refreshFromLocalStorage() async {
    try {
      final storedUser = await StorageService.getUser();
      if (storedUser != null && _currentUser?.id != storedUser.id) {
        _currentUser = storedUser;
        notifyListeners();
      }
    } catch (e) {
      print('Error refreshing from local storage: $e');
    }
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Check if user profile is complete
  bool get isProfileComplete => _currentUser?.hasCompleteProfile ?? false;
  
  // Get profile completion percentage
  double get profileCompletionPercentage => _currentUser?.profileCompletionPercentage ?? 0.0;

  // Biometric authentication methods
  Future<bool> isBiometricAvailable() async {
    return await _biometricService.isAvailable();
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _biometricService.getAvailableBiometrics();
  }

  Future<User?> authenticateWithBiometrics() async {
    try {
      _setStatus(AuthStatus.loading);
      _clearError();
      
      // Check if biometrics are available
      if (!await _biometricService.isAvailable()) {
        _setError('Biometric authentication is not available on this device');
        return null;
      }
      
      // Perform biometric authentication
      final isAuthenticated = await _biometricService.authenticate();
      if (!isAuthenticated) {
        _setError('Biometric authentication failed');
        _setStatus(AuthStatus.unauthenticated);
        return null;
      }
      
      // If biometric auth succeeds, restore user from storage
      final storedUser = await StorageService.getUser();
      if (storedUser != null) {
        _currentUser = storedUser;
        await _sessionService.createSession(storedUser);
        _setStatus(AuthStatus.authenticated);
        print('User authenticated with biometrics: ${storedUser.email}');
        return storedUser;
      } else {
        _setError('No stored user data found');
        _setStatus(AuthStatus.unauthenticated);
        return null;
      }
    } catch (e) {
      _setError('Error during biometric authentication: $e');
      return null;
    }
  }

  // Enable biometric authentication for current user
  Future<bool> enableBiometricAuth() async {
    try {
      if (_currentUser == null) {
        _setError('No user is currently signed in');
        return false;
      }
      
      // Check if biometrics are available
      if (!await _biometricService.isAvailable()) {
        _setError('Biometric authentication is not available on this device');
        return false;
      }
      
      // Perform biometric authentication to confirm it's the same user
      final isAuthenticated = await _biometricService.authenticate();
      if (!isAuthenticated) {
        _setError('Biometric authentication failed');
        return false;
      }
      
      // Store biometric preference
      await StorageService.saveSettings({'biometricEnabled': true});
      
      print('Biometric authentication enabled for user: ${_currentUser!.email}');
      return true;
    } catch (e) {
      _setError('Error enabling biometric authentication: $e');
      return false;
    }
  }

  // Check if biometric authentication is enabled
  Future<bool> isBiometricEnabled() async {
    try {
      final settings = await StorageService.getSettings();
      return settings['biometricEnabled'] == true;
    } catch (e) {
      return false;
    }
  }
} 