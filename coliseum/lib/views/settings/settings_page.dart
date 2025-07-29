import 'package:coliseum/services/settings_service.dart';
import 'package:coliseum/services/localization_service.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/widgets/form/custom_button.dart';
import 'package:coliseum/widgets/form/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'es';
  bool _biometricEnabled = false;

  final Map<String, String> _languages = {
    'es': 'Español',
    'en': 'English',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settingsService = Provider.of<SettingsService>(context, listen: false);
    setState(() {
      _selectedLanguage = settingsService.language;
      _biometricEnabled = settingsService.biometricEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer3<SettingsService, AuthViewModel, LocalizationService>(
        builder: (context, settingsService, authViewModel, localizationService, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Account Section
              _buildSectionHeader('Cuenta'),
              _buildProfileTile(authViewModel),
              const SizedBox(height: 16),
              
              // Appearance Section
              _buildSectionHeader('Apariencia'),
              _buildDarkModeTile(settingsService),
              _buildLanguageTile(settingsService),
              const SizedBox(height: 16),
              
              // Security Section
              _buildSectionHeader('Seguridad'),
              _buildBiometricTile(settingsService, authViewModel),
              _buildChangePasswordTile(authViewModel),
              const SizedBox(height: 16),
              
              // About Section
              _buildSectionHeader('Acerca de'),
              _buildAboutTile(),
              const SizedBox(height: 16),
              
              // Logout Section
              _buildLogoutTile(authViewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildProfileTile(AuthViewModel authViewModel) {
    final user = authViewModel.user;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user?.profileImageUrl ?? ''),
        radius: 25,
      ),
      title: Text(user?.fullName ?? user?.username ?? 'Usuario'),
      subtitle: Text(user?.email ?? ''),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/profile'),
    );
  }

  Widget _buildDarkModeTile(SettingsService settingsService) {
    return SwitchListTile(
      title: const Text('Modo oscuro'),
      subtitle: const Text('Cambiar entre tema claro y oscuro'),
      value: settingsService.isDarkMode,
      onChanged: (value) {
        settingsService.toggleDarkMode();
      },
      secondary: Icon(
        settingsService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
      ),
    );
  }

  Widget _buildLanguageTile(SettingsService settingsService) {
    return ListTile(
      title: const Text('Idioma'),
      subtitle: Text(_languages[settingsService.language] ?? 'Español'),
      leading: const Icon(Icons.language),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageDialog(settingsService),
    );
  }

  Widget _buildBiometricTile(SettingsService settingsService, AuthViewModel authViewModel) {
    return FutureBuilder<bool>(
      future: authViewModel.isBiometricAvailable(),
      builder: (context, snapshot) {
        final isAvailable = snapshot.data ?? false;
        
        if (!isAvailable) {
          return const ListTile(
            title: Text('Autenticación biométrica'),
            subtitle: Text('No disponible en este dispositivo'),
            leading: Icon(Icons.fingerprint),
            enabled: false,
          );
        }

        return SwitchListTile(
          title: const Text('Autenticación biométrica'),
          subtitle: const Text('Usar huella digital o Face ID'),
          value: settingsService.biometricEnabled,
          onChanged: (value) {
            settingsService.setBiometricEnabled(value);
          },
          secondary: const Icon(Icons.fingerprint),
        );
      },
    );
  }

  Widget _buildChangePasswordTile(AuthViewModel authViewModel) {
    return ListTile(
      title: const Text('Cambiar contraseña'),
      subtitle: const Text('Actualizar tu contraseña de acceso'),
      leading: const Icon(Icons.lock),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showChangePasswordDialog(authViewModel),
    );
  }

  Widget _buildAboutTile() {
    return ListTile(
      title: const Text('Acerca de Coliseum'),
      subtitle: const Text('Versión 2.0.0'),
      leading: const Icon(Icons.info),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showAboutDialog(),
    );
  }

  Widget _buildLogoutTile(AuthViewModel authViewModel) {
    return ListTile(
      title: const Text('Cerrar sesión'),
      leading: const Icon(Icons.logout, color: Colors.red),
      onTap: () => _showLogoutDialog(authViewModel),
    );
  }

  void _showLanguageDialog(SettingsService settingsService) {
    final localizationService = Provider.of<LocalizationService>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: settingsService.language,
              onChanged: (value) {
                if (value != null) {
                  settingsService.setLanguage(value, localizationService);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(AuthViewModel authViewModel) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: currentPasswordController,
                hintText: 'Contraseña actual',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña actual es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: newPasswordController,
                hintText: 'Nueva contraseña',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La nueva contraseña es obligatoria';
                  }
                  if (value.length < 6) {
                    return 'Mínimo 6 caracteres';
                  }
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$').hasMatch(value)) {
                    return 'Debe tener mayúscula, minúscula y número';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: confirmPasswordController,
                hintText: 'Confirmar nueva contraseña',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirma la nueva contraseña';
                  }
                  if (value != newPasswordController.text) {
                    return 'Las contraseñas no coinciden';
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
                    final success = await authViewModel.changePassword(
                      currentPasswordController.text,
                      newPasswordController.text,
                    );
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contraseña actualizada exitosamente'),
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
                  : const Text('Cambiar'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acerca de Coliseum'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Coliseum 2.0'),
            SizedBox(height: 8),
            Text('Una plataforma social moderna'),
            SizedBox(height: 8),
            Text('Versión: 2.0.0'),
            SizedBox(height: 8),
            Text('Desarrollado con Flutter'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(AuthViewModel authViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authViewModel.logout();
              Navigator.pop(context);
              context.go('/auth');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
} 