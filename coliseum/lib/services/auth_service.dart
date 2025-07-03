import 'package:coliseum/models/user_model.dart';

abstract class AuthService {
  Future<User?> get currentUser;
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User> signUp(String username, String email, String password);
} 