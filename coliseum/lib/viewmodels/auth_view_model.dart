import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/services/production_auth_service.dart';
import 'package:coliseum/services/biometric_service.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  final ProductionAuthService _prodAuthService;
  final BiometricService _biometricService;

  AuthViewModel(this._authService)
      : _prodAuthService = ProductionAuthService(),
        _biometricService = BiometricService();

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null;

  // Error handling
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Regular email/password login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      _user = await _prodAuthService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      final user = await _prodAuthService.signInWithGoogle();
      _user = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error signing in with Google: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Biometric authentication
  Future<bool> authenticateWithBiometrics() async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      final isAvailable = await _biometricService.isBiometricAvailable();
      if (!isAvailable) {
        _setError('Biometric authentication is not available');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final success = await _biometricService.authenticate();
      if (success) {
        // For demo purposes, we'll use a mock user
        // In a real app, you'd retrieve the stored user credentials
        _user = User(
          id: 'biometric_user',
          username: 'biometric_user',
          email: 'biometric@coliseum.com',
          profileImageUrl: 'https://i.pravatar.cc/150?u=biometric',
          authProvider: 'biometric',
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _setError('Biometric authentication failed');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setError('Error with biometric authentication: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Password reset
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      await _prodAuthService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error resetting password: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? bio,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    if (_user == null) return false;

    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _user = _user!.copyWith(
        username: username,
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error updating profile: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      await _prodAuthService.updatePassword(newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error changing password: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      _user = await _prodAuthService.signUp(username, email, password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      await _prodAuthService.logout();
      _user = null;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Error logging out: ${e.toString()}');
      notifyListeners();
    }
  }

  // Check if biometric is available
  Future<bool> isBiometricAvailable() async {
    return await _biometricService.isBiometricAvailable();
  }

  // Get available biometric types
  Future<List<String>> getAvailableBiometricTypes() async {
    final biometrics = await _biometricService.getAvailableBiometrics();
    return biometrics.map((type) {
      switch (type) {
        case BiometricType.fingerprint:
          return 'Fingerprint';
        case BiometricType.face:
          return 'Face ID';
        case BiometricType.iris:
          return 'Iris';
        default:
          return 'Biometric';
      }
    }).toList();
  }
} 