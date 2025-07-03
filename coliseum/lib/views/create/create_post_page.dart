import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/widgets/form/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onShare() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement actual post creation logic
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Propiedad publicada (simulado)')),
        );
        GoRouter.of(context).go(AppRoutes.home);
      }
    }
  }

  void _onCancel() {
    if (mounted) {
      GoRouter.of(context).go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: _onCancel,
          child: const Text('Cancelar'),
        ),
        title: const Text('Nueva Propiedad'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onShare,
            child: const Text('Publicar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, width: 2)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 60,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Añadir fotos y videos',
                      style: TextStyle(color: Colors.grey[800]),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _titleController,
                hintText: 'Título de la propiedad (ej. Villa de lujo en Casa de Campo)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  if (value.trim().length > 100) {
                    return 'Máximo 100 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                hintText: 'Describe la propiedad...',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  if (value.trim().length > 500) {
                    return 'Máximo 500 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _priceController,
                hintText: 'Precio (ej. 250,000 USD)',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El precio es obligatorio';
                  }
                  final num? price = num.tryParse(value.replaceAll(',', '').replaceAll('USD', '').trim());
                  if (price == null || price <= 0) {
                    return 'Introduce un precio válido mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _locationController,
                hintText: 'Ubicación (ej. La Romana, República Dominicana)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La ubicación es obligatoria';
                  }
                  if (value.trim().length > 100) {
                    return 'Máximo 100 caracteres';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 