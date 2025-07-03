import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel(this._authService);

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // In a real app, you'd handle this error.
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    try {
      _user = await _authService.signUp(username, email, password);
      notifyListeners();
    } catch (e) {
      // In a real app, you'd handle this error.
      print(e);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
} 