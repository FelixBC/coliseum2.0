import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/services/production_auth_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/services/mock_auth_service.dart';

// Simple mock auth service for testing core functionality
class SimpleAuthService extends ProductionAuthService {
  User? _currentUser;
  String? _authToken;
  
  String? get authToken => _authToken;
  bool get isAuthenticated => _currentUser != null && _authToken != null;
  
  @override
  Future<User?> get currentUser async => _currentUser;

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email inválido');
    }
    
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    
    // Test user validation
    if (email.toLowerCase() == 'test@coliseum.com') {
      if (password != 'password') {
        throw Exception('Contraseña incorrecta');
      }
      
      final user = User(
        id: 'test_user',
        username: 'testuser',
        email: 'test@coliseum.com',
        profileImageUrl: 'https://i.pravatar.cc/150?u=test',
        bio: 'Test user',
        postCount: 0,
        followers: 0,
        following: 0,
        firstName: 'Test',
        lastName: 'User',
        phoneNumber: '',
        dateOfBirth: null,
        authProvider: 'email',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      _currentUser = user;
      _authToken = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
      return user;
    }
    
    // Generic user validation
    if (password != 'password123') {
      throw Exception('Contraseña incorrecta');
    }
    
    final user = User(
      id: 'user_${email.hashCode}',
      username: email.split('@').first,
      email: email,
      profileImageUrl: 'https://i.pravatar.cc/150?u=${email}',
      bio: 'Generic user',
      postCount: 0,
      followers: 0,
      following: 0,
      firstName: email.split('@').first,
      lastName: 'User',
      phoneNumber: '',
      dateOfBirth: null,
      authProvider: 'email',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
    
    _currentUser = user;
    _authToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _currentUser = null;
    _authToken = null;
  }

  @override
  Future<User> signUp(String username, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email inválido');
    }
    
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    
    if (username.isEmpty || username.length < 3) {
      throw Exception('El nombre de usuario debe tener al menos 3 caracteres');
    }
    
    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      profileImageUrl: 'https://i.pravatar.cc/150?u=${email}',
      bio: 'New user',
      postCount: 0,
      followers: 0,
      following: 0,
      firstName: username,
      lastName: '',
      phoneNumber: '',
      dateOfBirth: null,
      authProvider: 'email',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
    
    _currentUser = user;
    _authToken = 'signup_token_${DateTime.now().millisecondsSinceEpoch}';
    return user;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Core Authentication Tests', () {
    late SimpleAuthService authService;
    late AuthViewModel authViewModel;
    late MockAuthService mockAuthService;

    setUp(() async {
      authService = SimpleAuthService();
      mockAuthService = MockAuthService();
      authViewModel = AuthViewModel(mockAuthService, prodAuthService: authService);
      
      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 100));
    });

    tearDown(() async {
      // Clean up by logging out
      await authService.logout();
    });

    test('should initialize with no authenticated user', () {
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.user, null);
    });

    test('should authenticate test user with valid credentials', () async {
      final result = await authViewModel.login('test@coliseum.com', 'password');
      
      expect(result, true);
      expect(authViewModel.isAuthenticated, true);
      expect(authViewModel.user, isNotNull);
      expect(authViewModel.user!.email, 'test@coliseum.com');
      expect(authViewModel.user!.username, 'testuser');
      expect(authViewModel.user!.authProvider, 'email');
    });

    test('should reject invalid password for test user', () async {
      final result = await authViewModel.login('test@coliseum.com', 'wrongpassword');
      
      expect(result, false);
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.user, null);
      expect(authViewModel.errorMessage, isNotNull);
      expect(authViewModel.errorMessage!.contains('Contraseña incorrecta'), true);
    });

    test('should handle generic user login', () async {
      final result = await authViewModel.login('user@example.com', 'password123');
      
      expect(result, true);
      expect(authViewModel.isAuthenticated, true);
      expect(authViewModel.user, isNotNull);
      expect(authViewModel.user!.email, 'user@example.com');
      expect(authViewModel.user!.authProvider, 'email');
    });

    test('should reject invalid password for generic user', () async {
      final result = await authViewModel.login('user@example.com', 'wrongpassword');
      
      expect(result, false);
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.user, null);
      expect(authViewModel.errorMessage, isNotNull);
    });

    test('should handle logout properly', () async {
      // First login
      await authViewModel.login('test@coliseum.com', 'password');
      expect(authViewModel.isAuthenticated, true);
      
      // Then logout
      await authViewModel.logout();
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.user, null);
    });

    test('should validate email format', () async {
      final result = await authViewModel.login('invalid-email', 'password123');
      
      expect(result, false);
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.errorMessage, isNotNull);
      expect(authViewModel.errorMessage!.contains('Email inválido'), true);
    });

    test('should validate password length', () async {
      final result = await authViewModel.login('user@example.com', '123');
      
      expect(result, false);
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.errorMessage, isNotNull);
      expect(authViewModel.errorMessage!.contains('al menos 6 caracteres'), true);
    });

    test('should handle user signup', () async {
      await authViewModel.signUp('newuser', 'newuser@example.com', 'password123');
      
      expect(authViewModel.isAuthenticated, true);
      expect(authViewModel.user, isNotNull);
      expect(authViewModel.user!.email, 'newuser@example.com');
      expect(authViewModel.user!.username, 'newuser');
      expect(authViewModel.user!.authProvider, 'email');
    });

    test('should validate signup requirements', () async {
      // Test short username
      try {
        await authViewModel.signUp('ab', 'user@example.com', 'password123');
        fail('Should have thrown an exception for short username');
      } catch (e) {
        expect(e.toString().contains('al menos 3 caracteres'), true);
      }
    });

    test('should handle loading states correctly', () async {
      // Start login
      final loginFuture = authViewModel.login('test@coliseum.com', 'password');
      
      // Check loading state
      expect(authViewModel.isLoading, true);
      
      // Wait for completion
      await loginFuture;
      
      // Check final state
      expect(authViewModel.isLoading, false);
      expect(authViewModel.isAuthenticated, true);
    });
  });
} 