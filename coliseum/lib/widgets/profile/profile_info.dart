import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileInfo extends StatelessWidget {
  final User user;

  const ProfileInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'SF Pro Display',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.bio ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 15,
              fontFamily: 'SF Pro Text',
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButtons(context, localizationService),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, LocalizationService localizationService) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              localizationService.get('editProfile'), 
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).primaryColor),
              foregroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              localizationService.get('share'), 
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
          ),
        ),
      ],
    );
  }
} 