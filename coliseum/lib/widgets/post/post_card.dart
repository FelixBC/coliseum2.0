import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/widgets/post/post_actions_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar and Username
          _buildHeader(context),
          // Image
          _buildImage(context),
          PostActionsBar(post: post),
          // Likes and Caption
          _buildLikes(context),
          _buildCaption(context),
          _buildComments(context),
          _buildDate(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[200],
            backgroundImage: post.user.profileImageUrl.startsWith('assets/')
                ? AssetImage(post.user.profileImageUrl) as ImageProvider
                : NetworkImage(post.user.profileImageUrl),
            onBackgroundImageError: (_, __) => const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            post.user.username,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final isLocal = post.imageUrl.startsWith('assets/');
    final imageWidget = isLocal
        ? Image.asset(
            post.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.width,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              );
            },
          )
        : FadeInImage.assetNetwork(
            placeholder: 'assets/images/profiles/rochyrd.jpg',
            image: post.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.width,
            imageErrorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              );
            },
          );
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.propertyDetail, extra: post);
      },
      child: Hero(
        tag: 'post_${post.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: imageWidget,
        ),
      ),
    );
  }

  Widget _buildLikes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        '${post.likes} likes',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCaption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '${post.user.username} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: post.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildComments(BuildContext context) {
    if (post.comments.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          context.push(AppRoutes.comments, extra: post);
        },
        child: Text(
          'View all ${post.comments.length} comments',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Text(
        'September 19', // Placeholder date
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10),
      ),
    );
  }
} 