import 'package:coliseum/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    String route;
    switch (index) {
      case 0:
        route = AppRoutes.home;
        break;
      case 1:
        route = AppRoutes.explore;
        break;
      case 2:
        route = AppRoutes.messages;
        break;
      case 3:
        route = AppRoutes.myProfile;
        break;
      default:
        route = AppRoutes.home;
    }
    
    if (context.mounted) {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildTabItem(
            context: context,
            icon: Icons.home_outlined,
            label: 'Home',
            index: 0,
          ),
          _buildTabItem(
            context: context,
            icon: Icons.search_outlined,
            label: 'Explore',
            index: 1,
          ),
          const SizedBox(width: 48), // Space for the FAB
          _buildTabItem(
            context: context,
            icon: Icons.message_outlined,
            label: 'Messages',
            index: 2,
          ),
          _buildTabItem(
            context: context,
            icon: Icons.person_outline,
            label: 'Profile',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onTap(context, index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
} 