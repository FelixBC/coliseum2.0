import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/services/localization_service.dart';
import 'package:coliseum/services/settings_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/viewmodels/home_view_model.dart';
import 'package:coliseum/viewmodels/profile_view_model.dart';
import 'package:coliseum/viewmodels/saved_view_model.dart';
import 'package:coliseum/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:coliseum/firebase_options.dart';
import 'package:coliseum/services/mock_post_service.dart';
import 'package:coliseum/services/mock_user_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase only if not already initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase might already be initialized, continue
    print('Firebase initialization note: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocalizationService(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsService(),
        ),
        // Provide a single shared instance of the real AuthService
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(
            MockPostService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(
            MockUserService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SavedViewModel(),
        ),
      ],
      child: Consumer2<LocalizationService, SettingsService>(
        builder: (context, localizationService, settingsService, child) {
          final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
          final appRouter = AppRouter(authViewModel);
          
          return MaterialApp.router(
            title: 'Coliseum',
            theme: settingsService.currentTheme,
            routerConfig: appRouter.router,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('es', 'ES'),
            ],
            locale: Locale(localizationService.currentLanguage),
          );
        },
      ),
    );
  }
} 