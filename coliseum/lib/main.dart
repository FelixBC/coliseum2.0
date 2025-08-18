import 'package:coliseum/constants/theme.dart';
import 'package:coliseum/router.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/services/mock_auth_service.dart';
import 'package:coliseum/services/mock_post_service.dart';
import 'package:coliseum/services/mock_user_service.dart';
import 'package:coliseum/services/post_service.dart';
import 'package:coliseum/services/user_service.dart';
import 'package:coliseum/services/user_specific_post_service.dart';
import 'package:coliseum/services/settings_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/viewmodels/home_view_model.dart';
import 'package:coliseum/viewmodels/profile_view_model.dart';
import 'package:coliseum/viewmodels/saved_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:coliseum/firebase_options.dart';
import 'package:coliseum/services/production_auth_service.dart';
import 'package:coliseum/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize production auth service
  final authService = ProductionAuthService();
  await authService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => authService),
        Provider<PostService>(create: (_) => UserSpecificPostService(MockPostService())),
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
        ChangeNotifierProvider(
          create: (context) => SavedViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsService(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalizationService(),
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
    final settingsService = Provider.of<SettingsService>(context);
    final appRouter = AppRouter(authViewModel);

    return Consumer<SettingsService>(
      builder: (context, settingsService, child) {
        return MaterialApp.router(
          title: 'Coliseum',
          theme: settingsService.currentTheme,
          routerConfig: appRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
} 