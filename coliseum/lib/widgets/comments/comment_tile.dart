import 'package:coliseum/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  // Helper function to determine if an image is a local asset
  bool isLocalAsset(String url) {
    return url.startsWith('assets/') || url.startsWith('file://');
  }

  // Helper function to get the correct image provider
  ImageProvider getImageProvider(String url) {
    if (url.isEmpty) return const AssetImage('assets/images/logo/whitelogo.png');
    if (isLocalAsset(url)) {
      return AssetImage(url);
    } else {
      return NetworkImage(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: getImageProvider(comment.user.profileImageUrl),
            onBackgroundImageError: (_, __) => const Icon(Icons.person, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '2h ago',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Like',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Reply',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 