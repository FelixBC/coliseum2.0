import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/services/localization_service.dart';
import 'package:coliseum/services/settings_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.5,
        title: Text(
          localizationService.get('settings'),
          style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.foregroundColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileSection(context, authViewModel, localizationService),
              const SizedBox(height: 24),
              _buildSettingsSection(context, localizationService),
              const SizedBox(height: 24),
              _buildSecuritySection(context, authViewModel, localizationService),
              const SizedBox(height: 24),
              _buildAccountSection(context, authViewModel, localizationService),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AuthViewModel authViewModel, LocalizationService localizationService) {
    final user = authViewModel.user;
    if (user == null) return const SizedBox.shrink();

    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: getImageProvider(user.profileImageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () => context.push(AppRoutes.editProfile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, LocalizationService localizationService) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              localizationService.get('settings'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildSettingTile(
            context,
            icon: Icons.language,
            title: localizationService.get('language'),
            subtitle: localizationService.getCurrentLanguageName(),
            onTap: () => _showLanguageDialog(context, localizationService),
          ),
          Consumer<SettingsService>(
            builder: (context, settingsService, child) {
              return _buildSettingTile(
                context,
                icon: settingsService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                title: localizationService.get(settingsService.isDarkMode ? 'darkMode' : 'lightMode'),
                subtitle: settingsService.isDarkMode 
                    ? localizationService.get('enabled') 
                    : localizationService.get('disabled'),
                onTap: () => settingsService.toggleDarkMode(),
                trailing: Switch(
                  value: settingsService.isDarkMode,
                  onChanged: (value) => settingsService.toggleDarkMode(),
                  activeColor: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.notifications,
            title: localizationService.get('notifications'),
            subtitle: localizationService.get('enabled'),
            onTap: () {},
          ),
          _buildSettingTile(
            context,
            icon: Icons.privacy_tip,
            title: localizationService.get('privacy'),
            subtitle: localizationService.get('public'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, AuthViewModel authViewModel, LocalizationService localizationService) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              localizationService.get('security'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FutureBuilder<bool>(
            future: authViewModel.isBiometricEnabled(),
            builder: (context, snapshot) {
              final isEnabled = snapshot.data ?? false;
              return _buildSettingTile(
                context,
                icon: Icons.fingerprint,
                title: localizationService.get('biometricAuthentication'),
                subtitle: isEnabled ? localizationService.get('enabled') : localizationService.get('disabled'),
                onTap: () => authViewModel.toggleBiometricAuthentication(),
                trailing: Switch(
                  value: isEnabled,
                  onChanged: (value) => authViewModel.toggleBiometricAuthentication(),
                  activeColor: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, AuthViewModel authViewModel, LocalizationService localizationService) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              localizationService.get('account'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildSettingTile(
            context,
            icon: Icons.info,
            title: localizationService.get('about'),
            subtitle: '${localizationService.get('version')} 1.0.0',
            onTap: () {},
          ),
          _buildSettingTile(
            context,
            icon: Icons.logout,
            title: localizationService.get('logout'),
            subtitle: '',
            onTap: () => authViewModel.logout(),
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Theme.of(context).colorScheme.onSurface),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(
                color: textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            )
          : null,
      trailing: trailing ?? Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context, LocalizationService localizationService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          localizationService.get('language'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
              leading: Radio<String>(
                value: 'en',
                groupValue: localizationService.currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    localizationService.setLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Español', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
              leading: Radio<String>(
                value: 'es',
                groupValue: localizationService.currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    localizationService.setLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizationService.get('cancel'),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to determine if an image is a local asset
  bool isLocalAsset(String url) {
    return url.startsWith('assets/') || url.startsWith('file://');
  }

  // Helper function to get the correct image provider
  ImageProvider getImageProvider(String url) {
    if (url.isEmpty) return const AssetImage('assets/images/logo/whitelogo.png');
    if (isLocalAsset(url)) {
      return AssetImage(url);
    } else {
      return NetworkImage(url);
    }
  }
} 