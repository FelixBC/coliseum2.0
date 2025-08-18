import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localizationService, child) {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildTabItem(
                context: context,
                icon: Icons.home_outlined,
                label: localizationService.get('home'),
                index: 0,
              ),
              _buildTabItem(
                context: context,
                icon: Icons.search_outlined,
                label: localizationService.get('explore'),
                index: 1,
              ),
              const SizedBox(width: 48), // Space for the FAB
              _buildTabItem(
                context: context,
                icon: Icons.message_outlined,
                label: localizationService.get('messages'),
                index: 2,
              ),
              _buildTabItem(
                context: context,
                icon: Icons.person_outline,
                label: localizationService.get('profile'),
                index: 3,
              ),
            ],
          ),
        );
      },
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
        onTap: () => onTabTapped(index),
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