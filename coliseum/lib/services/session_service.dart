import 'dart:async';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/storage_service.dart';
import 'package:coliseum/services/google_auth_service.dart';
import 'package:flutter/foundation.dart';

class SessionService extends ChangeNotifier {
  static const Duration _sessionTimeout = Duration(days: 30);
  static const Duration _refreshThreshold = Duration(hours: 24);
  
  Timer? _sessionTimer;
  Timer? _refreshTimer;
  User? _currentUser;
  bool _isSessionValid = false;
  DateTime? _lastActivity;
  
  // Getters
  User? get currentUser => _currentUser;
  bool get isSessionValid => _isSessionValid;
  bool get isAuthenticated => _currentUser != null && _isSessionValid;
  DateTime? get lastActivity => _lastActivity;
  DateTime? get sessionExpiry => _lastActivity?.add(_sessionTimeout);

  SessionService() {
    _initializeSession();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeSession() async {
    try {
      // Initialize storage
      await StorageService.initialize();
      
      // Check for existing session
      await _restoreSession();
      
      // Start session monitoring
      _startSessionMonitoring();
    } catch (e) {
      print('Error initializing session: $e');
      _isSessionValid = false;
      notifyListeners();
    }
  }

  Future<void> _restoreSession() async {
    try {
      final hasValidData = await StorageService.hasValidUserData();
      if (hasValidData) {
        final storedUser = await StorageService.getUser();
        final lastLogin = await StorageService.getLastLogin();
        
        if (storedUser != null && lastLogin != null) {
          _currentUser = storedUser;
          _lastActivity = lastLogin;
          
          // Check if session is still valid
          if (_isSessionExpired()) {
            await _clearSession();
          } else {
            _isSessionValid = true;
            print('Session restored for user: ${storedUser.email}');
          }
        }
      }
    } catch (e) {
      print('Error restoring session: $e');
      await _clearSession();
    }
  }

  Future<void> createSession(User user) async {
    try {
      _currentUser = user;
      _lastActivity = DateTime.now();
      _isSessionValid = true;
      
      // Store user data
      await StorageService.saveUser(user);
      
      // Start session monitoring
      _startSessionMonitoring();
      
      print('Session created for user: ${user.email}');
      notifyListeners();
    } catch (e) {
      print('Error creating session: $e');
      rethrow;
    }
  }

  Future<void> extendSession() async {
    if (_currentUser != null) {
      _lastActivity = DateTime.now();
      await StorageService.saveUser(_currentUser!);
      print('Session extended for user: ${_currentUser!.email}');
      notifyListeners();
    }
  }

  Future<void> _clearSession() async {
    try {
      _currentUser = null;
      _isSessionValid = false;
      _lastActivity = null;
      
      // Clear stored data
      await StorageService.clearAllData();
      
      // Cancel timers
      _sessionTimer?.cancel();
      _refreshTimer?.cancel();
      
      print('Session cleared');
      notifyListeners();
    } catch (e) {
      print('Error clearing session: $e');
    }
  }

  Future<void> logout() async {
    await _clearSession();
  }

  void _startSessionMonitoring() {
    // Cancel existing timers
    _sessionTimer?.cancel();
    _refreshTimer?.cancel();
    
    if (_currentUser != null) {
      // Set up session expiry timer
      _sessionTimer = Timer(_sessionTimeout, () {
        print('Session expired for user: ${_currentUser!.email}');
        _clearSession();
      });
      
      // Set up refresh threshold timer
      _refreshTimer = Timer(_refreshThreshold, () {
        _checkSessionValidity();
      });
    }
  }

  Future<void> _checkSessionValidity() async {
    try {
      if (_currentUser == null) return;
      
      // Check if session is expired
      if (_isSessionExpired()) {
        await _clearSession();
        return;
      }
      
      // Check if we need to refresh the session
      if (_shouldRefreshSession()) {
        await _refreshSession();
      }
      
      // Set up next refresh check
      _refreshTimer?.cancel();
      _refreshTimer = Timer(_refreshThreshold, () {
        _checkSessionValidity();
      });
    } catch (e) {
      print('Error checking session validity: $e');
    }
  }

  Future<void> _refreshSession() async {
    try {
      if (_currentUser == null) return;
      
      // For Google users, try to refresh silently
      if (_currentUser!.authProvider == 'google') {
        final googleAuthService = GoogleAuthService();
        final refreshedUser = await googleAuthService.getCurrentUser();
        
        if (refreshedUser != null) {
          // Update user data
          _currentUser = _currentUser!.copyWith(
            lastLoginAt: DateTime.now(),
            profileImageUrl: refreshedUser.profileImageUrl ?? _currentUser!.profileImageUrl,
          );
          
          // Extend session
          await extendSession();
          
          print('Session refreshed for Google user: ${_currentUser!.email}');
        } else {
          // Google session expired, clear local session
          await _clearSession();
        }
      } else {
        // For other auth providers, just extend the session
        await extendSession();
      }
    } catch (e) {
      print('Error refreshing session: $e');
      // If refresh fails, clear the session
      await _clearSession();
    }
  }

  bool _isSessionExpired() {
    if (_lastActivity == null) return true;
    return DateTime.now().difference(_lastActivity!) > _sessionTimeout;
  }

  bool _shouldRefreshSession() {
    if (_lastActivity == null) return false;
    return DateTime.now().difference(_lastActivity!) > _refreshThreshold;
  }

  // Update user activity (call this when user interacts with the app)
  void updateActivity() {
    if (_isSessionValid) {
      _lastActivity = DateTime.now();
      // Reset the session timer
      _sessionTimer?.cancel();
      _sessionTimer = Timer(_sessionTimeout, () {
        print('Session expired due to inactivity');
        _clearSession();
      });
    }
  }

  // Get session information
  Map<String, dynamic> getSessionInfo() {
    return {
      'isValid': _isSessionValid,
      'userEmail': _currentUser?.email,
      'authProvider': _currentUser?.authProvider,
      'lastActivity': _lastActivity?.toIso8601String(),
      'sessionExpiry': sessionExpiry?.toIso8601String(),
      'timeUntilExpiry': sessionExpiry?.difference(DateTime.now()).inSeconds,
      'sessionDuration': _lastActivity != null 
          ? DateTime.now().difference(_lastActivity!).inSeconds 
          : 0,
    };
  }

  // Check if session is about to expire (within 1 hour)
  bool get isSessionExpiringSoon {
    if (sessionExpiry == null) return false;
    return DateTime.now().difference(sessionExpiry!).inHours.abs() <= 1;
  }

  // Get remaining session time
  Duration? get remainingSessionTime {
    if (sessionExpiry == null) return null;
    return sessionExpiry!.difference(DateTime.now());
  }

  // Force session refresh (useful for testing or manual refresh)
  Future<void> forceRefresh() async {
    await _refreshSession();
  }

  // Validate session without extending it
  bool validateSession() {
    if (_currentUser == null || _lastActivity == null) {
      return false;
    }
    
    final isValid = !_isSessionExpired();
    if (!isValid && _isSessionValid) {
      // Session just became invalid, clear it
      _clearSession();
    }
    
    return isValid;
  }
}
