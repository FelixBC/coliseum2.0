import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Cuenta'),
          ListTile(
            title: const Text('Editar Perfil'),
            subtitle: const Text('Cambia tu nombre, foto de perfil, biografía...'),
            leading: const Icon(Icons.account_circle_outlined),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implement navigation
            },
          ),
          ListTile(
            title: const Text('Guardados'),
            subtitle: const Text('Ver tus propiedades guardadas'),
            leading: const Icon(Icons.bookmark_border),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push(AppRoutes.saved);
            },
          ),
          ListTile(
            title: const Text('Cambiar Contraseña'),
            leading: const Icon(Icons.password_outlined),
            trailing: const Icon(Icons.arrow_forward_ios),
             onTap: () {},
          ),
          const Divider(),
          _buildSectionHeader(context, 'Apariencia'),
           SwitchListTile(
            title: const Text('Modo Oscuro'),
            subtitle: const Text('Habilitar el tema oscuro en toda la aplicación'),
            secondary: const Icon(Icons.palette_outlined),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (bool value) {
              // TODO: Implement theme switching logic
              // This usually requires a theme provider at the top of the widget tree
            },
          ),
           const Divider(),
          _buildSectionHeader(context, 'Notificaciones'),
          SwitchListTile(
            title: const Text('Nuevos Inmuebles'),
            subtitle: const Text('Recibir alertas de nuevas propiedades en tu zona'),
            secondary: const Icon(Icons.apartment_outlined),
            value: true,
            onChanged: (bool value) {},
          ),
          SwitchListTile(
            title: const Text('Mensajes Directos'),
             subtitle: const Text('Recibir notificaciones de nuevos mensajes'),
            secondary: const Icon(Icons.message_outlined),
            value: true,
            onChanged: (bool value) {},
          ),
           const Divider(),
           _buildSectionHeader(context, 'Soporte'),
           ListTile(
            title: const Text('Centro de Ayuda'),
            leading: const Icon(Icons.help_outline),
             trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Términos y Condiciones'),
            leading: const Icon(Icons.description_outlined),
             trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
} 