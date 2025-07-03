import 'package:coliseum/models/comment_model.dart';
import 'package:coliseum/models/user_model.dart';

class Post {
  final String id;
  final User user;
  final String imageUrl;
  final String caption;
  final int likes;
  final List<Comment> comments;
  final DateTime createdAt;
  final String? location;
  final DateTime? postedAt;
  bool isLiked;
  bool isFavorited;

  Post({
    required this.id,
    required this.user,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.createdAt,
    this.location,
    this.postedAt,
    this.isLiked = false,
    this.isFavorited = false,
  });
} 