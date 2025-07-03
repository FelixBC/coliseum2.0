import 'package:coliseum/models/user_model.dart';

class Story {
  final String id;
  final User user;
  final String imageUrl;
  final DateTime createdAt;

  Story({
    required this.id,
    required this.user,
    required this.imageUrl,
    required this.createdAt,
  });
} 