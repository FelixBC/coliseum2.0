import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/constants/theme.dart';
import 'package:coliseum/services/localization_service.dart';
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
    final authViewModel = Provider.of<AuthViewModel>(context);
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/images/logo/whitelogo.png',
                      height: 80,
                      width: 80,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Welcome Text
                  Text(
                    localizationService.get('login'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    hintText: localizationService.get('email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizationService.get('fieldRequired');
                      }
                      if (!value.contains('@')) {
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
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showForgotPasswordDialog(context),
                      child: Text(localizationService.get('forgotPassword')),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  Consumer<AuthViewModel>(
                    builder: (context, viewModel, child) {
                      return CustomButton(
                        text: localizationService.get('login'),
                        isLoading: viewModel.isLoading,
                        onPressed: viewModel.isLoading ? null : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            viewModel.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(localizationService.get('or'), style: TextStyle(color: Colors.grey.shade600)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Google Sign In Button
                  _buildGoogleSignInButton(authViewModel, localizationService),
                  const SizedBox(height: 12),
                  
                  // Biometric authentication button
                  _buildBiometricButton(authViewModel, localizationService),
                  const SizedBox(height: 12),
                  
                  _buildSignUpLink(context, localizationService),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Loading overlay
          if (authViewModel.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
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
        icon: Image.asset(
          'assets/images/logo/whitelogo.png',
          height: 24,
          width: 24,
        ),
        label: Text(localizationService.get('continueWithGoogle')),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
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

  void _showForgotPasswordDialog(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context, listen: false);
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
} 