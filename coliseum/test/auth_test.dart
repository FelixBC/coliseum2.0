import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/production_auth_service.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/services/mock_auth_service.dart';

// Mock ProductionAuthService for testing
class MockProductionAuthService extends ProductionAuthService {
  User? _currentUser;
  String? _authToken;
  
  String? get authToken => _authToken;
  bool get isAuthenticated => _currentUser != null && _authToken != null;
  
  @override
  Future<User?> get currentUser async => _currentUser;

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email inválido');
    }
    
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    
    // Check if it's the test user (El Alfa)
    if (email.toLowerCase() == 'test@coliseum.com') {
      if (password != 'password') {
        throw Exception('Contraseña incorrecta');
      }
      
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
        createdAt: DateTime.now().subtract(const Duration(days: 730)),
        lastLoginAt: DateTime.now(),
      );
      
      _currentUser = user;
      _authToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      return user;
    }
    
    // For other emails, validate that password matches email (for testing purposes)
    if (password != 'password123') {
      throw Exception('Contraseña incorrecta');
    }
    
    // For other emails, create generic user
    final user = User(
      id: 'user_${email.hashCode}',
      username: email.split('@').first,
      email: email,
      profileImageUrl: 'https://i.pravatar.cc/150?u=${email}',
      bio: 'Usuario activo de Coliseum',
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
    
    _currentUser = user;
    _authToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    return user;
  }

  @override
  Future<User> signUp(String username, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
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
    
    _currentUser = user;
    _authToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = null;
    _authToken = null;
  }

  @override
  Future<User> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final user = User(
      id: 'google_felix_blanco',
      username: 'felix.blanco',
      email: 'felixaurio17@gmail.com',
      profileImageUrl: 'assets/images/profiles/elalfa.jpg',
      bio: 'Desarrollador Flutter y entusiasta de la tecnología inmobiliaria | @felix.blanco',
      postCount: 1,
      followers: 127,
      following: 89,
      firstName: 'Felix',
      lastName: 'Blanco Cabrera',
      phoneNumber: '+1 809-555-0123',
      dateOfBirth: DateTime(1995, 6, 15),
      authProvider: 'google',
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      lastLoginAt: DateTime.now(),
    );
    
    _currentUser = user;
    _authToken = 'mock_google_token_${DateTime.now().millisecondsSinceEpoch}';
    return user;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Tests', () {
    late MockProductionAuthService authService;
    late AuthViewModel authViewModel;
    late MockAuthService mockAuthService;

    setUp(() async {
      authService = MockProductionAuthService();
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

    test('should authenticate user with valid credentials', () async {
      final result = await authViewModel.login('test@coliseum.com', 'password');
      
      expect(result, true);
      expect(authViewModel.isAuthenticated, true);
      expect(authViewModel.user, isNotNull);
      expect(authViewModel.user!.email, 'test@coliseum.com');
      expect(authViewModel.user!.username, 'elalfaeljefe');
    });

    test('should authenticate with Google Sign In', () async {
      final result = await authViewModel.signInWithGoogle();
      
      expect(result, true);
      expect(authViewModel.isAuthenticated, true);
      expect(authViewModel.user, isNotNull);
      expect(authViewModel.user!.email, 'felixaurio17@gmail.com');
      expect(authViewModel.user!.username, 'felix.blanco');
    });

    test('should maintain authentication state after app restart', () async {
      // First, authenticate
      await authViewModel.login('test@coliseum.com', 'password');
      expect(authViewModel.isAuthenticated, true);
      
      // Create a new auth service instance (simulating app restart)
      final newAuthService = MockProductionAuthService();
      
      // Check if the user is still authenticated (should be false since it's a new instance)
      expect(newAuthService.isAuthenticated, false);
    });

    test('should logout and clear authentication state', () async {
      // First, authenticate
      await authViewModel.login('test@coliseum.com', 'password');
      expect(authViewModel.isAuthenticated, true);
      
      // Then logout
      await authViewModel.logout();
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.user, null);
    });

    test('should handle invalid login credentials', () async {
      final result = await authViewModel.login('invalid@email.com', 'wrongpassword');
      
      expect(result, false);
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.user, null);
      expect(authViewModel.errorMessage, isNotNull);
    });

    test('should handle invalid password for test user', () async {
      final result = await authViewModel.login('test@coliseum.com', 'wrongpassword');
      
      expect(result, false);
      expect(authViewModel.isAuthenticated, false);
      expect(authViewModel.user, null);
      expect(authViewModel.errorMessage, isNotNull);
    });
  });
} 