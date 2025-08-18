import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/services/storage_service.dart';
import 'package:coliseum/services/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductionAuthService extends ChangeNotifier implements AuthService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  
  User? _currentUser;
  String? _authToken;
  String? _errorMessage;
  AuthStatus _status = AuthStatus.unauthenticated;
  final SessionService _sessionService = SessionService();
  
  String? get authToken => _authToken;
  bool get isAuthenticated => _currentUser != null && _authToken != null;
  
  @override
  User? get currentUser => _currentUser;
  
  @override
  String? get errorMessage => _errorMessage;
  
  @override
  bool get isLoading => _status == AuthStatus.loading;
  
  @override
  bool get isSessionValid => _sessionService.isSessionValid;
  
  @override
  bool get isSessionExpiringSoon => _sessionService.isSessionExpiringSoon;
  
  @override
  Duration? get remainingSessionTime => _sessionService.remainingSessionTime;
  
  @override
  AuthStatus get status => _status;
  
  @override
  bool get isProfileComplete => _currentUser?.hasCompleteProfile ?? false;
  
  @override
  double get profileCompletionPercentage => _currentUser?.profileCompletionPercentage ?? 0.0;

  ProductionAuthService() {
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
      await _loadStoredUser();
      
      if (_currentUser != null && _authToken != null) {
        // Create session with stored user
        await _sessionService.createSession(_currentUser!);
        _setStatus(AuthStatus.authenticated);
      } else {
        _setStatus(AuthStatus.unauthenticated);
      }
    } catch (e) {
      _errorMessage = 'Error initializing auth: $e';
      _setStatus(AuthStatus.error);
    }
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _setStatus(AuthStatus.error);
  }

  // Initialize service
  Future<void> initialize() async {
    await _loadStoredUser();
  }

  // Load stored user from SharedPreferences
  Future<void> _loadStoredUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      final token = prefs.getString(_tokenKey);
      
      if (userJson != null && token != null) {
        final userMap = json.decode(userJson);
        _currentUser = User(
          id: userMap['id'],
          username: userMap['username'],
          email: userMap['email'],
          profileImageUrl: userMap['profileImageUrl'],
          bio: userMap['bio'] ?? '',
          postCount: userMap['postCount'] ?? 0,
          followers: userMap['followers'] ?? 0,
          following: userMap['following'] ?? 0,
          firstName: userMap['firstName'],
          lastName: userMap['lastName'],
          phoneNumber: userMap['phoneNumber'],
          dateOfBirth: userMap['dateOfBirth'] != null 
              ? DateTime.parse(userMap['dateOfBirth']) 
              : null,
          authProvider: userMap['authProvider'] ?? 'email',
          createdAt: userMap['createdAt'] != null 
              ? DateTime.parse(userMap['createdAt']) 
              : null,
          lastLoginAt: userMap['lastLoginAt'] != null 
              ? DateTime.parse(userMap['lastLoginAt']) 
              : null,
        );
        _authToken = token;
      }
    } catch (e) {
      print('Error loading stored user: $e');
    }
  }

  // Save user to SharedPreferences
  Future<void> _saveUser(User user, String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userMap = {
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'profileImageUrl': user.profileImageUrl,
        'bio': user.bio,
        'postCount': user.postCount,
        'followers': user.followers,
        'following': user.following,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'phoneNumber': user.phoneNumber,
        'dateOfBirth': user.dateOfBirth?.toIso8601String(),
        'authProvider': user.authProvider,
        'createdAt': user.createdAt?.toIso8601String(),
        'lastLoginAt': user.lastLoginAt?.toIso8601String(),
      };
      
      await prefs.setString(_userKey, json.encode(userMap));
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  // Clear stored user
  Future<void> _clearStoredUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
    } catch (e) {
      print('Error clearing stored user: $e');
    }
  }

  // Generate random token
  String _generateToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(32, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  // Store user data locally
  Future<void> _storeUserData(User user) async {
    try {
      await StorageService.saveUser(user);
      await StorageService.saveAuthToken(_authToken ?? '');
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  // Clear local user data
  Future<void> _clearUserData() async {
    try {
      await StorageService.deleteUser();
      await StorageService.deleteAuthToken();
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      _setStatus(AuthStatus.loading);
      
      // Use existing login method
      final user = await login(email, password);
      
      // Store user data locally and create session
      await _storeUserData(user);
      await _sessionService.createSession(user);
      
      _setStatus(AuthStatus.authenticated);
      return user;
    } catch (e) {
      _setError('Error signing in: $e');
      return null;
    }
  }

  @override
  Future<User?> signUpWithEmail(String email, String password, String username) async {
    try {
      _setStatus(AuthStatus.loading);
      
      // Use existing signUp method
      final user = await signUp(username, email, password);
      
      // Store user data locally and create session
      await _storeUserData(user);
      await _sessionService.createSession(user);
      
      _setStatus(AuthStatus.authenticated);
      return user;
    } catch (e) {
      _setError('Error signing up: $e');
      return null;
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      _setStatus(AuthStatus.loading);
      
      // Use existing Google sign in method
      final user = await _googleSignIn();
      
      // Store user data locally and create session
      await _storeUserData(user);
      await _sessionService.createSession(user);
      
      _setStatus(AuthStatus.authenticated);
      return user;
    } catch (e) {
      _setError('Error signing in with Google: $e');
      return null;
    }
  }

  // Google Sign In (renamed to avoid conflict)
  Future<User> _googleSignIn() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Always create Felix's profile for Google login
    final user = User(
      id: 'google_felix_blanco',
      username: 'felix.blanco',
      email: 'felixaurio17@gmail.com',
      profileImageUrl: 'assets/images/profiles/elalfa.jpg', // TODO: Replace with your actual photo
      bio: 'Desarrollador Flutter y entusiasta de la tecnología inmobiliaria | @felix.blanco',
      postCount: 1, // Only 1 property as requested
      followers: 127,
      following: 89,
      firstName: 'Felix',
      lastName: 'Blanco Cabrera',
      phoneNumber: '+1 809-555-0123',
      dateOfBirth: DateTime(1995, 6, 15), // Example date
      authProvider: 'google',
      createdAt: DateTime.now().subtract(const Duration(days: 180)), // 6 months ago
      lastLoginAt: DateTime.now(),
    );
    
    final token = _generateToken();
    _currentUser = user;
    _authToken = token;
    await _saveUser(user, token);
    
    return user;
  }

  @override
  Future<void> signOut() async {
    try {
      _setStatus(AuthStatus.loading);
      
      // Clear session and local user data
      await _sessionService.logout();
      _currentUser = null;
      _authToken = null;
      await _clearUserData();
      
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _setError('Error signing out: $e');
    }
  }

  @override
  Future<void> updateProfile(User updatedUser) async {
    try {
      if (_currentUser == null) {
        throw Exception('Usuario no autenticado');
      }
      
      // Update user data
      _currentUser = updatedUser;
      await _storeUserData(updatedUser);
      await _sessionService.extendSession();
      notifyListeners();
    } catch (e) {
      _setError('Error updating profile: $e');
    }
  }

  // Email/Password Sign Up (renamed to avoid conflict)
  Future<User> signUp(String username, String email, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Validate input
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email inválido');
    }
    
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    
    // Validate username
    if (username.isEmpty || username.length < 3) {
      throw Exception('El nombre de usuario debe tener al menos 3 caracteres');
    }
    
    // Simulate user creation
    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      profileImageUrl: 'https://i.pravatar.cc/150?u=${email}',
      bio: 'Bienvenido a Coliseum!',
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
    
    final token = _generateToken();
    
    _currentUser = user;
    _authToken = token;
    
    await _saveUser(user, token);
    
    return user;
  }

  // Email/Password Sign In (renamed to avoid conflict)
  Future<User> login(String email, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Validate input
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email inválido');
    }
    
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    
    // Check if it's the test user (El Alfa)
    if (email.toLowerCase() == 'test@coliseum.com') {
      // Create El Alfa's profile with Felix's Instagram
      final user = User(
        id: 'el_alfa_user',
        username: 'elalfaeljefe',
        email: 'test@coliseum.com',
        profileImageUrl: 'assets/images/profiles/elalfa.jpg',
        bio: 'El Jefe del Dembow 🎵 | Inmobiliaria El Jefe Records | @felix.blanco',
        postCount: 15,
        followers: 7800000,
        following: 15,
        firstName: 'El Alfa',
        lastName: 'El Jefe',
        phoneNumber: '+1 809-555-0001',
        dateOfBirth: DateTime(1990, 12, 4),
        authProvider: 'email',
        createdAt: DateTime.now().subtract(const Duration(days: 730)), // 2 years ago
        lastLoginAt: DateTime.now(),
      );
      
      final token = _generateToken();
      _currentUser = user;
      _authToken = token;
      await _saveUser(user, token);
      
      return user;
    }
    
    // For other email logins, create generic user
    final user = User(
      id: 'user_${email.hashCode}',
      username: email.split('@').first,
      email: email,
      profileImageUrl: 'https://i.pravatar.cc/150?u=${email}',
      bio: 'Usuario activo de Coliseum',
      postCount: Random().nextInt(50) + 10,
      followers: Random().nextInt(200) + 50,
      following: Random().nextInt(100) + 20,
      firstName: email.split('@').first,
      lastName: 'Usuario',
      phoneNumber: '+1${Random().nextInt(900000000) + 100000000}',
      dateOfBirth: DateTime(1990 + Random().nextInt(20), Random().nextInt(12) + 1, Random().nextInt(28) + 1),
      authProvider: 'email',
      createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(365) + 30)),
      lastLoginAt: DateTime.now(),
    );
    
    final token = _generateToken();
    
    _currentUser = user;
    _authToken = token;
    
    await _saveUser(user, token);
    
    return user;
  }

  // Sign Out (renamed to avoid conflict)
  Future<void> logout() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = null;
    _authToken = null;
    
    await _clearStoredUser();
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Validate email
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email inválido');
    }
    
    // Simulate sending email
    print('Password reset email sent to: $email');
    print('Reset link: https://coliseum.app/reset-password?token=${_generateToken()}');
  }

  // Update Password
  Future<void> updatePassword(String newPassword) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (newPassword.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    
    if (_currentUser == null) {
      throw Exception('Usuario no autenticado');
    }
    
    // Simulate password update
    print('Password updated successfully for user: ${_currentUser!.email}');
  }

  // Update Profile (renamed to avoid conflict)
  Future<void> updateProfileOld({
    String? displayName,
    String? photoURL,
    String? firstName,
    String? lastName,
    String? bio,
    String? phoneNumber,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (_currentUser == null) {
      throw Exception('Usuario no autenticado');
    }
    
    // Update user data
    _currentUser = _currentUser!.copyWith(
      username: displayName ?? _currentUser!.username,
      profileImageUrl: photoURL ?? _currentUser!.profileImageUrl,
      firstName: firstName ?? _currentUser!.firstName,
      lastName: lastName ?? _currentUser!.lastName,
      bio: bio ?? _currentUser!.bio,
      phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
    );
    
    // Save updated user
    if (_authToken != null) {
      await _saveUser(_currentUser!, _authToken!);
    }
    
    print('Profile updated successfully for user: ${_currentUser!.email}');
  }

  // Check if user is authenticated
  bool get isLoggedIn => _currentUser != null && _authToken != null;

  // Session management methods
  @override
  Future<void> extendSession() async {
    await _sessionService.extendSession();
  }

  @override
  Future<void> refreshSession() async {
    await _sessionService.forceRefresh();
  }

  @override
  void updateActivity() {
    _sessionService.updateActivity();
  }

  @override
  bool validateSession() {
    return _sessionService.validateSession();
  }

  // Check if user has valid local data
  @override
  Future<bool> hasValidLocalData() async {
    try {
      return await StorageService.hasValidUserData();
    } catch (e) {
      return false;
    }
  }

  // Refresh user data from local storage
  @override
  Future<void> refreshFromLocalStorage() async {
    try {
      final user = await StorageService.getUser();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      print('Error refreshing from local storage: $e');
    }
  }

  // Get authentication provider
  @override
  Future<String?> getAuthProvider() async {
    try {
      return await StorageService.getAuthProvider();
    } catch (e) {
      return null;
    }
  }

  // Get last login time
  @override
  Future<DateTime?> getLastLogin() async {
    try {
      return await StorageService.getLastLogin();
    } catch (e) {
      return null;
    }
  }

  // Get storage statistics
  @override
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      return await StorageService.getStorageStats();
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Get session information
  @override
  Map<String, dynamic> getSessionInfo() {
    return _sessionService.getSessionInfo();
  }
} 