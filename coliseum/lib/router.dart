import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/viewmodels/home_view_model.dart';
import 'package:coliseum/viewmodels/profile_view_model.dart';
import 'package:coliseum/viewmodels/saved_view_model.dart';
import 'package:coliseum/views/auth/login_page.dart';
import 'package:coliseum/views/auth/register_page.dart';
import 'package:coliseum/views/booking/booking_calendar_page.dart';
import 'package:coliseum/views/booking/property_detail_page.dart';
import 'package:coliseum/views/comments/comments_page.dart';
import 'package:coliseum/views/create/create_post_page.dart';
import 'package:coliseum/views/explore/explore_page.dart';
import 'package:coliseum/views/home/home_page.dart';
import 'package:coliseum/views/messages/messages_page.dart';
import 'package:coliseum/views/messages/chat_page.dart';
import 'package:coliseum/views/profile/profile_page.dart';
import 'package:coliseum/views/profile/edit_profile_page.dart';
import 'package:coliseum/views/saved/saved_page.dart';
import 'package:coliseum/views/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  final AuthViewModel authViewModel;

  AppRouter(this.authViewModel);

  late final GoRouter router = GoRouter(
    refreshListenable: authViewModel,
    initialLocation: AppRoutes.home,
    redirect: (BuildContext context, GoRouterState state) {
      final bool onAuthRoute = state.matchedLocation == AppRoutes.auth || state.matchedLocation == '/auth/register';

      final bool loggedIn = authViewModel.isAuthenticated;

      if (!loggedIn && !onAuthRoute) {
        return AppRoutes.auth;
      }

      if (loggedIn && onAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: <RouteBase>[
      // Auth routes
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Main app routes
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.explore,
        builder: (context, state) => const ExplorePage(),
      ),
      GoRoute(
        path: AppRoutes.messages,
        builder: (context, state) => const MessagesPage(),
      ),
      GoRoute(
        path: AppRoutes.myProfile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.saved,
        builder: (context, state) => const SavedPage(),
      ),
      
      // Other routes
      GoRoute(
        path: AppRoutes.comments,
        builder: (context, state) {
          final post = state.extra as Post;
          return CommentsPage(post: post);
        },
      ),
      GoRoute(
        path: AppRoutes.createPost,
        builder: (context, state) => const CreatePostPage(),
      ),
      GoRoute(
        path: AppRoutes.propertyDetail,
        builder: (context, state) {
          final post = state.extra as Post;
          return PropertyDetailPage(post: post);
        },
        routes: [
          GoRoute(
            path: AppRoutes.bookingCalendar,
            builder: (context, state) {
              final post = state.extra as Post;
              return BookingCalendarPage(propertyId: post.id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) => ChatPage(),
      ),
      GoRoute(
        path: AppRoutes.newMessage,
        builder: (context, state) => Scaffold(
          backgroundColor: const Color(0xFF000000),
          appBar: AppBar(
            backgroundColor: const Color(0xFF000000),
            elevation: 0.5,
            title: const Text('Nuevo mensaje', style: TextStyle(color: Colors.white)),
          ),
          body: const Center(
            child: Text('Aquí puedes buscar usuarios para chatear', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ],
  );
} 