import 'package:coliseum/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[900],
        backgroundImage: comment.user.profileImageUrl.startsWith('assets/')
            ? AssetImage(comment.user.profileImageUrl) as ImageProvider
            : NetworkImage(comment.user.profileImageUrl),
        onBackgroundImageError: (_, __) => const Icon(Icons.person, color: Colors.white),
        radius: 18,
      ),
      title: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '${comment.user.username} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: comment.text),
          ],
        ),
      ),
      subtitle: Text(
        '5m ago', // Placeholder for time
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.favorite_border, size: 16),
        onPressed: () {
          // Handle liking a comment
        },
      ),
    );
  }
} 