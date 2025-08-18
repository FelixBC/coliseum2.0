import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/constants/theme.dart';
import 'package:coliseum/services/localization_service.dart';
import 'package:coliseum/services/settings_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/widgets/form/custom_button.dart';
import 'package:coliseum/widgets/form/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'test@coliseum.com');
    _passwordController = TextEditingController(text: 'password');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final localizationService = Provider.of<LocalizationService>(context, listen: false);
    final settingsService = Provider.of<SettingsService>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top controls bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Language selector
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.language,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                      tooltip: 'Cambiar idioma',
                      onSelected: (String languageCode) {
                        localizationService.setLanguage(languageCode);
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'en',
                          child: Row(
                            children: [
                              Text('🇺🇸 '),
                              const SizedBox(width: 8),
                              const Text('English'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'es',
                          child: Row(
                            children: [
                              Text('🇪🇸 '),
                              const SizedBox(width: 8),
                              const Text('Español'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Theme toggle
                    IconButton(
                      onPressed: () {
                        settingsService.toggleDarkMode();
                      },
                      icon: Icon(
                        settingsService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                      tooltip: settingsService.isDarkMode ? 'Modo claro' : 'Modo oscuro',
                    ),
                  ],
                ),
              ),
              
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        
                        // Logo or App Name
                        Text(
                          'Coliseum',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Email Field
                        CustomTextField(
                          controller: _emailController,
                          hintText: localizationService.get('email'),
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizationService.get('fieldRequired');
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return localizationService.get('invalidEmail');
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Password Field
                        CustomTextField(
                          controller: _passwordController,
                          hintText: localizationService.get('password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizationService.get('fieldRequired');
                            }
                            if (value.length < 6) {
                              return localizationService.get('passwordTooShort');
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _showForgotPasswordDialog(context, localizationService);
                            },
                            child: Text(
                              localizationService.get('forgotPassword'),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Sign In Button
                        CustomButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await authViewModel.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                              if (success && mounted) {
                                context.go(AppRoutes.home);
                              }
                            }
                          },
                          text: localizationService.get('signIn'),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Google Sign In Button
                        _buildGoogleSignInButton(authViewModel, localizationService),
                        
                        const SizedBox(height: 16),
                        
                        // Biometric Login Button
                        CustomButton(
                          onPressed: () async {
                            print('=== BIOMETRIC BUTTON PRESSED ===');
                            // Show biometric authentication modal
                            final success = await _showBiometricModal(context);
                            print('=== MODAL RESULT: $success ===');
                            
                            if (mounted && success) {
                              print('=== NAVIGATING TO HOME ===');
                              // Navigate to home on successful authentication
                              context.go(AppRoutes.home);
                            } else {
                              print('=== NOT NAVIGATING: mounted=$mounted, success=$success ===');
                            }
                          },
                          text: localizationService.get('useFingerprint'),
                          leadingIcon: Icon(
                            Icons.fingerprint,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Sign Up Link
                        _buildSignUpLink(context, localizationService),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(AuthViewModel authViewModel, LocalizationService localizationService) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: authViewModel.isLoading ? null : () async {
          await authViewModel.signInWithGoogle();
        },
        icon: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              'https://developers.google.com/identity/images/g-logo.png',
              width: 24,
              height: 24,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.g_mobiledata,
                    color: Colors.white,
                    size: 20,
                  ),
                );
              },
            ),
          ),
        ),
        label: Text(
          localizationService.get('continueWithGoogle'),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 1,
        ),
      ),
    );
  }

  Widget _buildBiometricButton(AuthViewModel authViewModel, LocalizationService localizationService) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: authViewModel.isLoading ? null : () async {
          await authViewModel.authenticateWithBiometrics();
        },
        icon: const Icon(Icons.fingerprint),
        label: Text(localizationService.get('useBiometric')),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context, LocalizationService localizationService) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF121212),
            title: Text(
              localizationService.get('recoverPassword'),
              style: const TextStyle(color: Colors.white),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizationService.get('enterEmailForRecoveryLink'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: emailController,
                    hintText: localizationService.get('email'),
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return localizationService.get('fieldRequired');
                      }
                      if (!value.contains('@')) {
                        return localizationService.get('invalidEmail');
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  localizationService.get('cancel'),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              Consumer<AuthViewModel>(
                builder: (context, authViewModel, child) {
                  return ElevatedButton(
                    onPressed: isLoading ? null : () async {
                      if (formKey.currentState?.validate() ?? false) {
                        setState(() => isLoading = true);
                        
                        // Simulate password recovery
                        await Future.delayed(const Duration(seconds: 2));
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizationService.get('recoveryLinkSent')),
                            ),
                          );
                        }
                      }
                    },
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(localizationService.get('send')),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context, LocalizationService localizationService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          localizationService.get('dontHaveAccount'),
          style: TextStyle(color: Colors.grey[400]),
        ),
        TextButton(
          onPressed: () {
            context.go('/auth/register');
          },
          child: Text(localizationService.get('signUp')),
        ),
      ],
    );
  }

  Future<bool> _showBiometricModal(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Start authentication automatically when modal opens
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!authViewModel.isLoading) {
              _startBiometricAuthentication(context, authViewModel, setState);
            }
          });

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fingerprint icon with animation
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fingerprint,
                      size: 50,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    'Autenticación Biométrica',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    'Coloca tu dedo en el sensor de huella digital',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Loading indicator or error message
                  Consumer<AuthViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.errorMessage != null && viewModel.errorMessage!.isNotEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  viewModel.errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      if (viewModel.isLoading) {
                        return Column(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Verificando huella digital...',
                              style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      }
                      
                      return Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.fingerprint,
                              size: 40,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Esperando huella digital...',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel button
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      
                      // Retry button (only show when there's an error)
                      Consumer<AuthViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.errorMessage != null && viewModel.errorMessage!.isNotEmpty) {
                            return ElevatedButton(
                              onPressed: viewModel.isLoading ? null : () {
                                viewModel.clearError();
                                _startBiometricAuthentication(context, authViewModel, setState);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Reintentar'),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    
    return result ?? false;
  }

  // Helper method to start biometric authentication
  void _startBiometricAuthentication(BuildContext context, AuthViewModel authViewModel, StateSetter setState) {
    print('=== STARTING BIOMETRIC AUTHENTICATION ===');
    
    // Clear any previous errors
    authViewModel.clearError();
    
    // Start authentication process
    _performBiometricAuthentication(context, authViewModel, setState);
  }

  // Helper method to perform the actual authentication
  Future<void> _performBiometricAuthentication(BuildContext context, AuthViewModel authViewModel, StateSetter setState) async {
    try {
      print('=== PERFORMING BIOMETRIC AUTHENTICATION ===');
      
      final success = await authViewModel.authenticateWithBiometrics();
      print('=== AUTHENTICATION RESULT: $success ===');
      
      if (success) {
        print('=== AUTHENTICATION SUCCESSFUL, CLOSING MODAL ===');
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      } else {
        print('=== AUTHENTICATION FAILED, SHOWING ERROR ===');
        // Error will be shown in the UI above
        setState(() {});
        
        // Wait a bit and then retry automatically (like a real sensor would)
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted && !authViewModel.isLoading) {
          print('=== RETRYING AUTHENTICATION ===');
          _performBiometricAuthentication(context, authViewModel, setState);
        }
      }
    } catch (e) {
      print('=== AUTHENTICATION ERROR: $e ===');
      setState(() {});
    }
  }
} 