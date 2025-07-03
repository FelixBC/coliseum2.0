import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:coliseum/viewmodels/home_view_model.dart';
import 'package:coliseum/viewmodels/profile_view_model.dart';
import 'package:coliseum/widgets/common/error_display.dart';
import 'package:coliseum/widgets/common/profile_shimmer.dart';
import 'package:coliseum/widgets/common/view_state_builder.dart';
import 'package:coliseum/widgets/profile/post_grid.dart';
import 'package:coliseum/widgets/profile/profile_header.dart';
import 'package:coliseum/widgets/profile/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:coliseum/widgets/form/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch the profile for our main mock user "El Alfa"
      context.read<ProfileViewModel>().fetchUserProfile('el_alfa');
    });
  }

  @override
  Widget build(BuildContext context) {
    // By using a Consumer here, we can get the viewModel
    // to update the AppBar title dynamically.
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              viewModel.user?.username ?? 'Perfil', // Dynamic username
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.add_box_outlined)),
              IconButton(
                onPressed: () => _showSettingsMenu(context),
                icon: const Icon(Icons.menu),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(user: viewModel.user!),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          body: ViewStateBuilder(
                viewState: viewModel.state,
                loadingWidget: const ProfileShimmer(),
                errorWidget: ErrorDisplay(
                  message: viewModel.errorMessage,
                  onRetry: () => viewModel.fetchUserProfile('el_alfa'),
                ),
                builder: () {
                  // The user should not be null here, but we check for safety
                  if (viewModel.user == null) {
                    return ErrorDisplay(
                      message: 'User data could not be loaded.',
                      onRetry: () => viewModel.fetchUserProfile('el_alfa'),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => viewModel.fetchUserProfile('el_alfa'),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileHeader(user: viewModel.user!),
                          ProfileInfo(user: viewModel.user!),
                          const SizedBox(height: 24),
                          PostGrid(posts: viewModel.posts),
                        ],
                      ),
                    ),
                  );
                },
              ),
        );
      },
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(AppRoutes.settings);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Archive'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('QR Code'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AuthViewModel>().logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Nueva pantalla de edición de perfil
class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  File? _pickedImageFile;
  String? _networkImageUrl;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final List<String> allowedDomains = [
    'gmail.com', 'outlook.com', 'hotmail.com', 'yahoo.com',
    'coliseum.com', 'dembow.com', 'elJefe.com'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
    _bioController = TextEditingController(text: widget.user.bio);
    _emailController = TextEditingController(text: widget.user.email);
    if (widget.user.profileImageUrl.startsWith('http') || widget.user.profileImageUrl.startsWith('assets/')) {
      _networkImageUrl = widget.user.profileImageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _pickedImageFile = File(picked.path);
        _networkImageUrl = null;
      });
    }
  }

  void _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      String imagePath = '';
      if (_pickedImageFile != null) {
        imagePath = _pickedImageFile!.path;
      } else if (_networkImageUrl != null) {
        imagePath = _networkImageUrl!;
      }
      final updatedUser = User(
        id: widget.user.id,
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        profileImageUrl: imagePath,
        bio: _bioController.text.trim(),
        postCount: widget.user.postCount,
        followers: widget.user.followers,
        following: widget.user.following,
      );
      await context.read<ProfileViewModel>().updateProfile(updatedUser);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: _pickedImageFile != null
                          ? FileImage(_pickedImageFile!)
                          : (_networkImageUrl != null
                              ? (_networkImageUrl!.startsWith('assets/')
                                  ? AssetImage(_networkImageUrl!) as ImageProvider
                                  : NetworkImage(_networkImageUrl!))
                              : null),
                      child: _pickedImageFile == null && _networkImageUrl == null
                          ? const Icon(Icons.person, size: 48, color: Colors.white38)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nameController,
                hintText: 'Username',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre de usuario es obligatorio';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(value.trim())) {
                    return 'Solo letras, números y guion bajo (3-20)';
                  }
                  if (value.trim().toLowerCase() == _emailController.text.trim().toLowerCase()) {
                    return 'El usuario no puede ser igual al email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                    return 'Solo se permiten emails de: ' + allowedDomains.join(', ');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _bioController,
                hintText: 'Bio',
                prefixIcon: Icons.info_outline,
                maxLines: 2,
                validator: (value) {
                  if (value != null && value.length > 120) {
                    return 'Máximo 120 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  if (_pickedImageFile == null && _networkImageUrl == null) {
                    return const Text('Debes seleccionar una imagen de perfil', style: TextStyle(color: Colors.redAccent, fontSize: 13));
                  }
                  return const SizedBox.shrink();
                },
              ),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Nueva contraseña (opcional)',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$').hasMatch(value)) {
                      return 'Debe tener mayúscula, minúscula y número';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirmar nueva contraseña',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (_passwordController.text.isNotEmpty) {
                    if (value == null || value.isEmpty) {
                      return 'Confirma la contraseña';
                    }
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if ((_pickedImageFile != null || _networkImageUrl != null) && (_formKey.currentState?.validate() ?? false)) {
                    _onSave();
                  } else {
                    setState(() {}); // Para mostrar error de imagen
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0095F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar cambios', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 