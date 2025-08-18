import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/viewmodels/home_view_model.dart';
import 'package:coliseum/viewmodels/profile_view_model.dart';
import 'package:coliseum/widgets/common/error_display.dart';
import 'package:coliseum/widgets/common/profile_shimmer.dart';
import 'package:coliseum/widgets/common/view_state_builder.dart';
import 'package:coliseum/widgets/common/session_info_widget.dart';
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
import 'package:coliseum/mixins/user_activity_mixin.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with UserActivityMixin {
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
          // Session status indicator
          CompactSessionInfoWidget(
            onTap: () {
              // Show session info dialog or navigate to settings
              context.push(AppRoutes.settings);
            },
          ),
          const SizedBox(width: 8),
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
          // Get the current authenticated user
          final currentUser = authViewModel.user;
          
          if (currentUser == null) {
            return const Center(
              child: Text('No user logged in'),
            );
          }

          // Only fetch posts from ProfileViewModel, use user data directly from AuthViewModel
          if (!_hasLoadedProfile) {
            _lastUserId = currentUser.id;
            _hasLoadedProfile = true;
            // Fetch posts for the user
            Future.microtask(() {
              if (mounted) {
                profileViewModel.fetchUserProfile(currentUser.id);
              }
            });
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header with user data from AuthViewModel
                ProfileHeader(user: currentUser),
                
                // Profile Info with user data from AuthViewModel
                ProfileInfo(user: currentUser),
                
                // Session Info Widget
                SessionInfoWidget(
                  showExtendedInfo: true,
                  onExtendSession: () {
                    // Handle session extension
                  },
                  onRefreshSession: () {
                    // Handle session refresh
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Posts Grid (this comes from ProfileViewModel)
                ViewStateBuilder(
                  viewState: profileViewModel.state,
                  builder: () {
                    if (profileViewModel.posts.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'No posts yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return PostGrid(posts: profileViewModel.posts);
                  },
                  loadingWidget: const ProfileShimmer(),
                  errorWidget: ErrorDisplay(
                    message: profileViewModel.errorMessage ?? 'An error occurred',
                    onRetry: () => profileViewModel.fetchUserProfile(currentUser.id),
                  ),
                ),
              ],
            ),
          );
        },
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