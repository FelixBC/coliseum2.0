import 'package:coliseum/models/story_model.dart';
import 'package:flutter/material.dart';

class StoryAvatar extends StatelessWidget {
  final Story story;

  const StoryAvatar({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF0095F6), Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[900],
              backgroundImage: story.imageUrl.startsWith('assets/')
                  ? AssetImage(story.imageUrl) as ImageProvider
                  : NetworkImage(story.imageUrl),
              onBackgroundImageError: (_, __) => const Icon(Icons.person, color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            story.user.username,
            style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
} 