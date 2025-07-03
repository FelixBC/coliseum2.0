import 'package:coliseum/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.black,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Color(0xFF0095F6),
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 36,
                backgroundImage: user.profileImageUrl.startsWith('assets/')
                    ? AssetImage(user.profileImageUrl) as ImageProvider
                    : NetworkImage(user.profileImageUrl),
                backgroundColor: Colors.grey[200],
                onBackgroundImageError: (_, __) => const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Posts', user.postCount.toString()),
                _buildStatColumn('Followers', user.followers.toString()),
                _buildStatColumn('Following', user.following.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildStatColumn(String label, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFB3B3B3),
            fontFamily: 'SF Pro Display',
          ),
        ),
      ],
    );
  }
} 