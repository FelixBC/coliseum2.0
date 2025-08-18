import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/services/localization_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/views/explore/explore_page.dart';
import 'package:coliseum/views/home/home_page.dart';
import 'package:coliseum/views/messages/messages_page.dart';
import 'package:coliseum/views/profile/profile_page.dart';
import 'package:coliseum/views/saved/saved_page.dart';
import 'package:coliseum/widgets/navigation/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const HomePage(),      // 0 - Home
    const ExplorePage(),   // 1 - Explore  
    const MessagesPage(),  // 2 - Messages
    const ProfilePage(),   // 3 - Profile
    const SavedPage(),     // 4 - Saved
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: _currentIndex == 2 ? // Create post button on messages tab
        FloatingActionButton(
          heroTag: 'create_post_fab', // Add unique hero tag
          onPressed: () => context.push(AppRoutes.createPost),
          backgroundColor: const Color(0xFF0095F6),
          child: const Icon(Icons.add, color: Colors.white),
        ) : null,
      bottomNavigationBar: Consumer<LocalizationService>(
        builder: (context, localizationService, child) {
          return AppBottomNavigationBar(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
          );
        },
      ),
    );
  }
}
