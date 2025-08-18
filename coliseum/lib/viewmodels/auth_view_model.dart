import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/services/biometric_service.dart';
import 'package:coliseum/services/storage_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  final BiometricService _biometricService;

  AuthViewModel(this._authService)
      : _biometricService = BiometricService();

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null;

  // Error handling
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Prevent multiple rapid state changes
  bool _isUpdating = false;

  // Listen to auth service changes
  AuthService get authService => _authService;

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    _user = _authService.currentUser;
    _isLoading = _authService.isLoading;
    _errorMessage = _authService.errorMessage;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      if (!_isUpdating) {
        notifyListeners();
      }
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    if (_errorMessage != message) {
      _errorMessage = message;
      if (!_isUpdating) {
        notifyListeners();
      }
    }
  }

  // Initialize auth state
  Future<void> initialize() async {
    _authService.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  // Regular email/password login
  Future<bool> login(String email, String password) async {
    // Prevent multiple simultaneous login attempts
    if (_isLoading || _isUpdating) return false;
    
    _isLoading = true;
    _isUpdating = true;
    _clearError();
    
    try {
      final newUser = await _authService.signInWithEmail(email, password);
      
      if (newUser != null) {
        _user = newUser;
        _isLoading = false;
        _isUpdating = false;
        notifyListeners();
        return true;
      } else {
        _setError('Login failed. Please check your credentials.');
        _isLoading = false;
        _isUpdating = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _isLoading = false;
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  // Google Sign-In
  Future<bool> signInWithGoogle() async {
    if (_isLoading || _isUpdating) return false;
    
    _isLoading = true;
    _isUpdating = true;
    _clearError();
    
    try {
      final newUser = await _authService.signInWithGoogle();
      
      if (newUser != null) {
        _user = newUser;
        _isLoading = false;
        _isUpdating = false;
        notifyListeners();
        return true;
      } else {
        _setError('Google Sign-In failed. Please try again.');
        _isLoading = false;
        _isUpdating = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _isLoading = false;
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  // Biometric authentication methods
  Future<bool> isBiometricAvailable() async {
    return await _authService.isBiometricAvailable();
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _authService.getAvailableBiometrics();
  }

  Future<bool> authenticateWithBiometrics() async {
    if (_isLoading || _isUpdating) return false;
    
    _isLoading = true;
    _isUpdating = true;
    _clearError();
    
    try {
      final user = await _authService.authenticateWithBiometrics();
      
      if (user != null) {
        _user = user;
        _isLoading = false;
        _isUpdating = false;
        notifyListeners();
        return true;
      } else {
        _setError('Biometric authentication failed. Please try again.');
        _isLoading = false;
        _isUpdating = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _isLoading = false;
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> enableBiometricAuth() async {
    if (_isLoading || _isUpdating) return false;
    
    _isLoading = true;
    _isUpdating = true;
    _clearError();
    
    try {
      final success = await _authService.enableBiometricAuth();
      
      _isLoading = false;
      _isUpdating = false;
      notifyListeners();
      
      if (success) {
        return true;
      } else {
        _setError('Failed to enable biometric authentication');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _isLoading = false;
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> isBiometricEnabled() async {
    return await _authService.isBiometricEnabled();
  }

  // Test biometric authentication (for debugging)
  Future<bool> testBiometricAuth() async {
    return await _authService.authenticateWithBiometrics() != null;
  }

  // Toggle biometric authentication
  Future<void> toggleBiometricAuthentication() async {
    if (_isLoading || _isUpdating) return;
    
    try {
      final isCurrentlyEnabled = await _authService.isBiometricEnabled();
      
      if (isCurrentlyEnabled) {
        // Disable biometric authentication
        await StorageService.saveSettings({'biometricEnabled': false});
        notifyListeners();
      } else {
        // Enable biometric authentication
        await enableBiometricAuth();
      }
    } catch (e) {
      _setError('Error toggling biometric authentication: $e');
    }
  }

  // Sign up with email
  Future<bool> signUp(String username, String email, String password) async {
    if (_isLoading || _isUpdating) return false;
    
    _isLoading = true;
    _isUpdating = true;
    _clearError();
    
    try {
      final newUser = await _authService.signUpWithEmail(email, password, username);
      
      if (newUser != null) {
        _user = newUser;
        _isLoading = false;
        _isUpdating = false;
        notifyListeners();
        return true;
      } else {
        _setError('Sign up failed. Please try again.');
        _isLoading = false;
        _isUpdating = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _isLoading = false;
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    if (_isUpdating) return;
    
    _isUpdating = true;
    
    try {
      await _authService.signOut();
      _user = null;
      _isUpdating = false;
      notifyListeners();
    } catch (e) {
      _setError('Logout error: $e');
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<void> updateProfile(User updatedUser) async {
    if (_isUpdating) return;
    
    _isUpdating = true;
    
    try {
      await _authService.updateProfile(updatedUser);
      _user = updatedUser;
      _isUpdating = false;
      notifyListeners();
    } catch (e) {
      _setError('Profile update error: $e');
      _isUpdating = false;
      notifyListeners();
    }
  }
} 