import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/widgets/comments/comment_tile.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  final Post post;
  const CommentsPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: post.comments.length + 1, // +1 for the original post caption
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Render the original post as the first item
                  return _buildPostCaption();
                }
                final comment = post.comments[index - 1];
                return CommentTile(comment: comment);
              },
            ),
          ),
          const Divider(height: 1),
          _buildCommentInputField(context),
        ],
      ),
    );
  }

  Widget _buildPostCaption() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: post.user.profileImageUrl.startsWith('assets/')
                    ? AssetImage(post.user.profileImageUrl) as ImageProvider
                    : NetworkImage(post.user.profileImageUrl),
              ),
              const SizedBox(width: 12),
              Text(
                post.user.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.caption),
          const SizedBox(height: 16),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildCommentInputField(BuildContext context) {
    const currentUserImageUrl = 'assets/images/profiles/elalfa.jpg';

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 8.0,
        top: 8.0,
        bottom: 8.0 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[900],
            backgroundImage: currentUserImageUrl.startsWith('assets/')
                ? AssetImage(currentUserImageUrl) as ImageProvider
                : NetworkImage(currentUserImageUrl),
            onBackgroundImageError: (_, __) => const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Añade un comentario como El Alfa...',
                border: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Handle sending a comment
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }
} 