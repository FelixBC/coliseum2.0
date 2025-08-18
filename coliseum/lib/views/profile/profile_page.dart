import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/viewmodels/home_view_model.dart';
import 'package:coliseum/viewmodels/profile_view_model.dart';
import 'package:coliseum/widgets/common/error_display.dart';
import 'package:coliseum/widgets/common/profile_shimmer.dart';
import 'package:coliseum/widgets/common/view_state_builder.dart';
import 'package:coliseum/widgets/profile/post_grid.dart';
import 'package:coliseum/widgets/profile/profile_header.dart';
import 'package:coliseum/widgets/profile/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:coliseum/widgets/form/custom_text_field.dart';
import 'package:coliseum/widgets/navigation/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:coliseum/services/localization_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _hasLoadedProfile = false;
  String? _lastUserId;

  @override
  void initState() {
    super.initState();
    // Only load profile once when the component mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  void _loadUserProfile() {
    final authViewModel = context.read<AuthViewModel>();
    if (authViewModel.user != null && !_hasLoadedProfile) {
      _lastUserId = authViewModel.user!.id;
      context.read<ProfileViewModel>().fetchUserProfile(authViewModel.user!.id);
      _hasLoadedProfile = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = context.read<LocalizationService>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.5,
        title: Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            return Text(
              authViewModel.user?.username ?? localizationService.get('profile'),
              style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Theme.of(context).appBarTheme.foregroundColor),
            onPressed: () {
              context.push(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: Consumer2<ProfileViewModel, AuthViewModel>(
        builder: (context, profileViewModel, authViewModel, child) {
          // Only fetch profile when user actually changes
          if (authViewModel.user != null && 
              _lastUserId != authViewModel.user!.id) {
            _lastUserId = authViewModel.user!.id;
            _hasLoadedProfile = false;
            // Use a microtask to avoid multiple rebuilds
            Future.microtask(() {
              if (mounted) {
                profileViewModel.fetchUserProfile(authViewModel.user!.id);
                _hasLoadedProfile = true;
              }
            });
          }
          
          // Use a more efficient build pattern
          if (profileViewModel.state == ViewState.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          
          final userToShow = profileViewModel.user ?? authViewModel.user;
          if (userToShow != null) {
            return _buildProfileContent(context, userToShow);
          }
          
          return Center(
            child: Text(
              localizationService.get('noUserDataAvailable'),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return RefreshIndicator(
      onRefresh: () {
        if (context.read<AuthViewModel>().user != null) {
          return context.read<ProfileViewModel>().fetchUserProfile(context.read<AuthViewModel>().user!.id);
        }
        return Future.value();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(user: user),
            ProfileInfo(user: user),
            const SizedBox(height: 24),
            PostGrid(posts: context.read<ProfileViewModel>().posts),
          ],
        ),
      ),
    );
  }

  void _showSettingsMenu(BuildContext context) {
    final localizationService = context.read<LocalizationService>();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.onSurface),
                title: Text(
                  localizationService.get('settings'),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(AppRoutes.settings);
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: Theme.of(context).colorScheme.onSurface),
                title: Text(
                  localizationService.get('archive'),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: Icon(Icons.qr_code, color: Theme.of(context).colorScheme.onSurface),
                title: Text(
                  localizationService.get('qrCode'),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.onSurface),
                title: Text(
                  localizationService.get('logout'),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AuthViewModel>().logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }
} 