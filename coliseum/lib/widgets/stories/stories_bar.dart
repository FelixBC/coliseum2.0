import 'package:coliseum/models/story_model.dart';
import 'package:coliseum/widgets/stories/story_avatar.dart';
import 'package:flutter/material.dart';

class StoriesBar extends StatelessWidget {
  final List<Story> stories;
  const StoriesBar({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return StoryAvatar(story: stories[index]);
        },
      ),
    );
  }
} 