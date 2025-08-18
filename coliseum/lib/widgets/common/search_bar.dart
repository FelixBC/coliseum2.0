import 'package:flutter/material.dart';
import 'package:coliseum/services/localization_service.dart';
import 'package:provider/provider.dart';

class CustomSearchBar extends StatefulWidget {
  final void Function(String)? onSearch;
  final TextEditingController? controller;
  final String? hintText;
  const CustomSearchBar({Key? key, this.onSearch, this.controller, this.hintText}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController? _internalController;
  TextEditingController get _controller => widget.controller ?? _internalController!;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
  }

  void _validateAndSearch(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() => _errorText = 'Introduce al menos 2 caracteres');
      return;
    }
    if (trimmed.length < 2) {
      setState(() => _errorText = 'Introduce al menos 2 caracteres');
      return;
    }
    if (trimmed.length > 50) {
      setState(() => _errorText = 'Máximo 50 caracteres');
      return;
    }
    if (!RegExp(r'^[a-zA-Z0-9áéíóúÁÉÍÓÚüÜñÑ ]+$').hasMatch(trimmed)) {
      setState(() => _errorText = 'Solo letras y números');
      return;
    }
    setState(() => _errorText = null);
    if (widget.onSearch != null) {
      widget.onSearch!(trimmed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationService = Provider.of<LocalizationService>(context, listen: false);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor ?? Colors.grey[900],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: TextField(
            controller: _controller,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: widget.hintText ?? localizationService.get('search'),
              border: InputBorder.none,
              icon: const Icon(Icons.search),
              counterText: '',
            ),
            onSubmitted: _validateAndSearch,
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 2.0),
            child: Text(
              _errorText!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController?.dispose();
    }
    super.dispose();
  }
} 