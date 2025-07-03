import 'package:coliseum/models/post_model.dart';

abstract class PostService {
  Future<List<Post>> getFeedPosts();
} 