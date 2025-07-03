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
import 'package:coliseum/views/saved/saved_page.dart';
import 'package:coliseum/views/settings/settings_page.dart';
import 'package:coliseum/widgets/navigation/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorExploreKey = GlobalKey<NavigatorState>(debugLabel: 'shellExplore');
final _shellNavigatorMessagesKey = GlobalKey<NavigatorState>(debugLabel: 'shellMessages');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

class AppRouter {
  final AuthViewModel authViewModel;

  AppRouter(this.authViewModel);

  late final GoRouter router = GoRouter(
    refreshListenable: authViewModel,
    initialLocation: AppRoutes.home,
    navigatorKey: _rootNavigatorKey,
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(child: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Explore Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorExploreKey,
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                builder: (context, state) => const ExplorePage(),
              ),
            ],
          ),
          // Messages Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMessagesKey,
            routes: [
              GoRoute(
                path: AppRoutes.messages,
                builder: (context, state) => const MessagesPage(),
              ),
            ],
          ),
          // Profile Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: AppRoutes.myProfile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
        routes: [
          GoRoute(
            path: 'register', // Corresponds to /auth/register
            builder: (BuildContext context, GoRouterState state) {
              return const RegisterPage();
            },
          )
        ]),
      GoRoute(
        path: AppRoutes.comments,
        builder: (BuildContext context, GoRouterState state) {
          final post = state.extra as Post;
          return CommentsPage(post: post);
        },
      ),
      GoRoute(
        path: AppRoutes.createPost,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreatePostPage(),
      ),
      GoRoute(
        path: AppRoutes.propertyDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final post = state.extra as Post;
          return PropertyDetailPage(post: post);
        },
        routes: [
          GoRoute(
            path: AppRoutes.bookingCalendar,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final post = state.extra as Post;
              return BookingCalendarPage(propertyId: post.id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.saved,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SavedPage(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return ChatPage();
        },
      ),
      GoRoute(
        path: AppRoutes.newMessage,
        parentNavigatorKey: _rootNavigatorKey,
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