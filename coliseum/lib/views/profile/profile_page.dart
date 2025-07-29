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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  void _loadUserProfile() {
    final authViewModel = context.read<AuthViewModel>();
    if (authViewModel.user != null) {
      context.read<ProfileViewModel>().fetchUserProfile(authViewModel.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    // By using a Consumer here, we can get the viewModel
    // to update the AppBar title dynamically.
    return Consumer2<ProfileViewModel, AuthViewModel>(
      builder: (context, profileViewModel, authViewModel, child) {
        // Update profile when auth user changes
        if (authViewModel.user != null && 
            (profileViewModel.user == null || profileViewModel.user!.id != authViewModel.user!.id)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            profileViewModel.fetchUserProfile(authViewModel.user!.id);
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              profileViewModel.user?.username ?? 'Perfil',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.add_box_outlined)),
              IconButton(
                onPressed: () => _showSettingsMenu(context),
                icon: const Icon(Icons.menu),
              ),
              IconButton(
                onPressed: () {
                  context.push('/profile/edit');
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          body: ViewStateBuilder(
            viewState: profileViewModel.state,
            loadingWidget: const ProfileShimmer(),
            errorWidget: ErrorDisplay(
              message: profileViewModel.errorMessage,
              onRetry: () {
                final authViewModel = context.read<AuthViewModel>();
                if (authViewModel.user != null) {
                  profileViewModel.fetchUserProfile(authViewModel.user!.id);
                }
              },
            ),
            builder: () {
              // The user should not be null here, but we check for safety
              if (profileViewModel.user == null) {
                return ErrorDisplay(
                  message: 'User data could not be loaded.',
                  onRetry: () {
                    final authViewModel = context.read<AuthViewModel>();
                    if (authViewModel.user != null) {
                      profileViewModel.fetchUserProfile(authViewModel.user!.id);
                    }
                  },
                );
              }
              return RefreshIndicator(
                onRefresh: () {
                  final authViewModel = context.read<AuthViewModel>();
                  if (authViewModel.user != null) {
                    return profileViewModel.fetchUserProfile(authViewModel.user!.id);
                  }
                  return Future.value();
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeader(user: profileViewModel.user!),
                      ProfileInfo(user: profileViewModel.user!),
                      const SizedBox(height: 24),
                      PostGrid(posts: profileViewModel.posts),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push(AppRoutes.createPost),
            child: const Icon(Icons.add),
            elevation: 0,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
        );
      },
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(AppRoutes.settings);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Archive'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('QR Code'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
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