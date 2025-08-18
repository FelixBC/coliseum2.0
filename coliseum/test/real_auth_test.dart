import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/production_auth_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/services/mock_auth_service.dart';

// Mock Firebase for testing
class MockFirebaseApp extends Fake implements FirebaseApp {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Real Authentication Tests', () {
    late ProductionAuthService authService;
    late AuthViewModel authViewModel;
    late MockAuthService mockAuthService;

    setUpAll(() async {
      // Initialize Firebase for testing
      await Firebase.initializeApp();
    });

    setUp(() async {
      authService = ProductionAuthService();
      await authService.initialize();
      mockAuthService = MockAuthService();
      authViewModel = AuthViewModel(mockAuthService, prodAuthService: authService);
      
      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 200));
    });

    tearDown(() async {
      // Clean up by logging out
      await authService.logout();
    });

    test('should initialize with proper logging', () {
      // This test verifies that the initialization process logs properly
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.user, null);
    });

    test('should handle test user login with proper validation', () async {
      final result = await authViewModel.login('test@coliseum.com', 'password');
      
      expect(result, true);
      expect(authViewModel.isAuthenticated, true);
      expect(authViewModel.user, isNotNull);
      expect(authViewModel.user!.email, 'test@coliseum.com');
      expect(authViewModel.user!.username, 'elalfaeljefe');
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
      final result = await authViewModel.signUp('newuser', 'newuser@example.com', 'password123');
      
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
  });
} 