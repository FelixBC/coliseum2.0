import 'package:coliseum/models/comment_model.dart';
import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/models/story_model.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/viewmodels/home_view_model.dart';
import 'package:coliseum/widgets/common/error_display.dart';
import 'package:coliseum/widgets/common/post_list_shimmer.dart';
import 'package:coliseum/widgets/common/view_state_builder.dart';
import 'package:coliseum/widgets/post/post_card.dart';
import 'package:coliseum/widgets/stories/stories_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for stories, will be moved to a viewmodel later
    final mockUser1 = User(id: 'el_alfa', username: 'elalfaeljefe', email: '', profileImageUrl: 'assets/images/profiles/elalfa.jpg');
    final mockUser2 = User(id: 'rochyrd', username: 'rochyrd', email: '', profileImageUrl: 'assets/images/profiles/rochyrd.jpg');
    final mockUser3 = User(id: 'chimbala', username: 'chimbala', email: '', profileImageUrl: 'assets/images/profiles/chimbala.jpg');
    final mockStories = [
      Story(id: 's1', user: mockUser1, imageUrl: 'assets/images/profiles/elalfa.jpg', createdAt: DateTime.now()),
      Story(id: 's2', user: mockUser2, imageUrl: 'assets/images/profiles/rochyrd.jpg', createdAt: DateTime.now()),
      Story(id: 's3', user: mockUser3, imageUrl: 'assets/images/profiles/chimbala.jpg', createdAt: DateTime.now()),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0.5,
        title: const Text(
          'Coliseum',
          style: TextStyle(
            fontFamily: 'InstagramSans',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Color(0xFF0095F6)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.send_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return ViewStateBuilder(
            viewState: viewModel.state,
            loadingWidget: const PostListShimmer(),
            errorWidget: ErrorDisplay(
              message: viewModel.errorMessage,
              onRetry: () => viewModel.fetchPosts(),
            ),
            builder: () {
              return RefreshIndicator(
                onRefresh: () => viewModel.fetchPosts(),
                child: ListView.builder(
                  itemCount: viewModel.posts.length + 1, // +1 for stories
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return StoriesBar(stories: mockStories);
                    }
                    final post = viewModel.posts[index - 1];
                    return PostCard(post: post);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 