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
    // Get stories based on current user type
    final stories = _getStoriesForCurrentUser();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.5,
        title: Text(
          'Coliseum',
          style: TextStyle(
            fontFamily: 'InstagramSans',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white 
                : Colors.black,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border, 
              color: Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFF0095F6) 
                  : const Color(0xFF0095F6)
            ), 
            onPressed: () {}
          ),
          IconButton(
            icon: Icon(
              Icons.send_outlined, 
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black
            ), 
            onPressed: () {}
          ),
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
                      return StoriesBar(stories: stories);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createPost),
        child: const Icon(Icons.add),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  
  List<Story> _getStoriesForCurrentUser() {
    final now = DateTime.now();
    final minute = now.minute;
    
    // Felix's stories (when minute < 10)
    if (minute < 10) {
      final felixUser = User(
        id: 'google_felix_blanco', 
        username: 'felixaurio17', 
        email: 'felixaurio17@gmail.com', 
        profileImageUrl: 'https://i.pravatar.cc/150?u=felixaurio17@gmail.com'
      );
      
      return [
        Story(id: 'felix_s1', user: felixUser, imageUrl: 'assets/images/properties/airbnb.jpg', createdAt: DateTime.now()),
        Story(id: 'felix_s2', user: felixUser, imageUrl: 'assets/images/properties/airbnb2.jpg', createdAt: DateTime.now()),
        Story(id: 'felix_s3', user: felixUser, imageUrl: 'assets/images/properties/airbnb3.jpg', createdAt: DateTime.now()),
      ];
    }
    
    // Test user stories (when minute 10-19)
    if (minute < 20) {
      final mockUser1 = User(id: 'el_alfa', username: 'elalfaeljefe', email: '', profileImageUrl: 'assets/images/profiles/elalfa.jpg');
      final mockUser2 = User(id: 'rochyrd', username: 'rochyrd', email: '', profileImageUrl: 'assets/images/profiles/rochyrd.jpg');
      final mockUser3 = User(id: 'chimbala', username: 'chimbala', email: '', profileImageUrl: 'assets/images/profiles/chimbala.jpg');
      
      return [
        Story(id: 's1', user: mockUser1, imageUrl: 'assets/images/profiles/elalfa.jpg', createdAt: DateTime.now()),
        Story(id: 's2', user: mockUser2, imageUrl: 'assets/images/profiles/rochyrd.jpg', createdAt: DateTime.now()),
        Story(id: 's3', user: mockUser3, imageUrl: 'assets/images/profiles/chimbala.jpg', createdAt: DateTime.now()),
      ];
    }
    
    // Other users stories (default)
    final mockUser1 = User(id: 'el_alfa', username: 'elalfaeljefe', email: '', profileImageUrl: 'assets/images/profiles/elalfa.jpg');
    final mockUser2 = User(id: 'rochyrd', username: 'rochyrd', email: '', profileImageUrl: 'assets/images/profiles/rochyrd.jpg');
    final mockUser3 = User(id: 'chimbala', username: 'chimbala', email: '', profileImageUrl: 'assets/images/profiles/chimbala.jpg');
    
    return [
      Story(id: 's1', user: mockUser1, imageUrl: 'assets/images/profiles/elalfa.jpg', createdAt: DateTime.now()),
      Story(id: 's2', user: mockUser2, imageUrl: 'assets/images/profiles/rochyrd.jpg', createdAt: DateTime.now()),
      Story(id: 's3', user: mockUser3, imageUrl: 'assets/images/profiles/chimbala.jpg', createdAt: DateTime.now()),
    ];
  }
} 