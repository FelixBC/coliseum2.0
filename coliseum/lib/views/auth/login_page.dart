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
  bool _isBiometricAvailable = false;

  final List<String> allowedDomains = [
    'gmail.com', 'outlook.com', 'hotmail.com', 'yahoo.com',
    'coliseum.com', 'dembow.com', 'elJefe.com'
  ];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'test@coliseum.com');
    _passwordController = TextEditingController(text: 'password');
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final isAvailable = await authViewModel.isBiometricAvailable();
      if (mounted) {
        setState(() {
          _isBiometricAvailable = isAvailable;
        });
      }
    } catch (e) {
      // Silently handle errors to avoid crashes
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
        });
      }
    }
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

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'assets/images/logo/whitelogo.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              const Text(
                'Coliseum',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'InstagramSans',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Error message display
              if (authViewModel.errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    authViewModel.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),

              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El email es obligatorio';
                  }
                  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Introduce un email válido';
                  }
                  final domain = value.trim().split('@').last;
                  if (!allowedDomains.any((d) => domain.endsWith(d))) {
                    return 'Solo se permiten emails de Gmail, Outlook, Hotmail o Yahoo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es obligatoria';
                  }
                  if (value.length < 6) {
                    return 'Mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              
              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPasswordDialog(context),
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ),
              
              const SizedBox(height: 20),
              Consumer<AuthViewModel>(
                builder: (context, viewModel, child) {
                  return CustomButton(
                    text: 'Log In',
                    isLoading: viewModel.isLoading,
                    onPressed: () {
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
                    child: Text('O', style: TextStyle(color: Colors.grey.shade600)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 16),
              
              // Google Sign In Button
              _buildGoogleSignInButton(authViewModel),
              const SizedBox(height: 12),
              
              // Biometric authentication button
              _buildBiometricButton(authViewModel),
              const SizedBox(height: 12),
              
              _buildSignUpLink(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(AuthViewModel authViewModel) {
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
        label: const Text('Continuar con Google'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildBiometricButton(AuthViewModel authViewModel) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: authViewModel.isLoading ? null : () async {
          await authViewModel.authenticateWithBiometrics();
        },
        icon: const Icon(Icons.fingerprint),
        label: const Text('Usar huella digital'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ingresa tu email para recibir un enlace de recuperación'),
              const SizedBox(height: 16),
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El email es obligatorio';
                  }
                  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Introduce un email válido';
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
            child: const Text('Cancelar'),
          ),
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return ElevatedButton(
                onPressed: authViewModel.isLoading ? null : () async {
                  if (formKey.currentState?.validate() ?? false) {
                    final success = await authViewModel.resetPassword(emailController.text);
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Se ha enviado un enlace de recuperación a tu email'),
                        ),
                      );
                    }
                  }
                },
                child: authViewModel.isLoading 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Enviar'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.grey[400]),
        ),
        TextButton(
          onPressed: () {
            context.go('/auth/register');
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
} 