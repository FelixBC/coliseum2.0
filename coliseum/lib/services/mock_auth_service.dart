import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/services/mock_user_service.dart';

class MockAuthService implements AuthService {
  User? _currentUser;
  // Mapa de email a contraseña para usuarios registrados en sesión
  final Map<String, String> _sessionPasswords = {};
  final MockUserService _userService = MockUserService();

  @override
  Future<User?> get currentUser async {
    return _currentUser;
  }

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Primero, login hardcodeado
    if (email == 'test@coliseum.com' && password == 'password') {
      _currentUser = User(
        id: '1',
        username: 'testuser',
        email: email,
        profileImageUrl: 'https://i.pravatar.cc/150?u=testuser',
      );
      return _currentUser!;
    }
    // Buscar usuario en mock y sesión
    final user = _userService.findUserByEmail(email);
    if (user != null) {
      // Si es usuario de sesión, validar contraseña
      if (_sessionPasswords.containsKey(email.toLowerCase())) {
        if (_sessionPasswords[email.toLowerCase()] == password) {
          _currentUser = user;
          return user;
        } else {
          throw Exception('Contraseña incorrecta');
        }
      } else {
        // Para usuarios mock, permitir login sin password (o puedes agregar lógica extra)
        _currentUser = user;
        return user;
      }
    }
    throw Exception('Credenciales inválidas');
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  Future<User> signUp(String username, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Validar que no exista
    if (_userService.findUserByEmail(email) != null) {
      throw Exception('El email ya está registrado');
    }
    if (_userService.findUserByUsername(username) != null) {
      throw Exception('El usuario ya existe');
    }
    final user = _userService.registerUser(username: username, email: email, password: password);
    _sessionPasswords[email.toLowerCase()] = password;
    _currentUser = user;
    return user;
  }
} 