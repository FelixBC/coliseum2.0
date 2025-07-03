import 'package:coliseum/viewmodels/home_view_model.dart'; // Contains ViewState enum
import 'package:flutter/material.dart';

class ViewStateBuilder extends StatelessWidget {
  final ViewState viewState;
  final Widget Function() builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const ViewStateBuilder({
    super.key,
    required this.viewState,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    switch (viewState) {
      case ViewState.loading:
        return loadingWidget ?? const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return errorWidget ?? const Center(child: Text('An error occurred.'));
      case ViewState.idle:
      default:
        return builder();
    }
  }
} 