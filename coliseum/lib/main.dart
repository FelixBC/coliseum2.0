import 'package:coliseum/constants/theme.dart';
import 'package:coliseum/router.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/services/mock_auth_service.dart';
import 'package:coliseum/services/mock_post_service.dart';
import 'package:coliseum/services/mock_user_service.dart';
import 'package:coliseum/services/post_service.dart';
import 'package:coliseum/services/user_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/viewmodels/home_view_model.dart';
import 'package:coliseum/viewmodels/profile_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => MockAuthService()),
        Provider<PostService>(create: (_) => MockPostService()),
        Provider<UserService>(create: (_) => MockUserService()),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(context.read<PostService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(context.read<UserService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final appRouter = AppRouter(authViewModel);

    return MaterialApp.router(
      title: 'Coliseum',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
} 