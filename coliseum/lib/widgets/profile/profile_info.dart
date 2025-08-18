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
          // Display name (preferred over username)
          Text(
            user.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'SF Pro Display',
            ),
          ),
          const SizedBox(height: 4),
          // Username with @ symbol
          Text(
            '@${user.username}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 16,
              fontFamily: 'SF Pro Text',
            ),
          ),
          const SizedBox(height: 8),
          // Bio
          if (user.bio.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.bio,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          // Additional profile information
          _buildProfileDetails(context, localizationService),
          const SizedBox(height: 16),
          // Action buttons
          _buildActionButtons(context, localizationService),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, LocalizationService localizationService) {
    final details = <Widget>[];
    
    // Email (if available and different from username)
    if (user.email.isNotEmpty && user.email != user.username) {
      details.add(_buildDetailRow(
        context,
        Icons.email_outlined,
        user.email,
        Theme.of(context).colorScheme.onSurfaceVariant,
      ));
    }
    
    // Location
    if (user.location != null && user.location!.isNotEmpty) {
      details.add(_buildDetailRow(
        context,
        Icons.location_on_outlined,
        user.location!,
        Theme.of(context).colorScheme.onSurfaceVariant,
      ));
    }
    
    // Website
    if (user.website != null && user.website!.isNotEmpty) {
      details.add(_buildDetailRow(
        context,
        Icons.link,
        user.website!,
        Theme.of(context).colorScheme.primary,
      ));
    }
    
    // Auth provider info
    if (user.authProvider == 'google') {
      details.add(_buildDetailRow(
        context,
        Icons.verified,
        'Verified with Google',
        Colors.blue,
      ));
    }
    
    // Member since
    if (user.createdAt != null) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final date = user.createdAt!;
      final month = months[date.month - 1];
      final year = date.year;
      
      details.add(_buildDetailRow(
        context,
        Icons.calendar_today_outlined,
        'Member since $month $year',
        Theme.of(context).colorScheme.onSurfaceVariant,
      ));
    }
    
    if (details.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: details.map((detail) => detail).toList(),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontFamily: 'SF Pro Text',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, LocalizationService localizationService) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to edit profile
            },
            icon: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 18,
            ),
            label: Text(
              localizationService.get('editProfile'), 
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Share profile
            },
            icon: Icon(
              Icons.share_outlined,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
            label: Text(
              localizationService.get('share'), 
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).primaryColor),
              foregroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
} 