import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/models/user_model.dart';

abstract class UserService {
  Future<User> getUserProfile(String userId);
  Future<List<Post>> getUserPosts(String userId);
  Future<User> updateUserProfile(User user);
} 