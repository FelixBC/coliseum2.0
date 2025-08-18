import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coliseum/services/auth_service.dart';

mixin UserActivityMixin<T extends StatefulWidget> on State<T> {
  Timer? _activityTimer;
  static const Duration _activityThreshold = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _startActivityMonitoring();
  }

  @override
  void dispose() {
    _activityTimer?.cancel();
    super.dispose();
  }

  void _startActivityMonitoring() {
    // Update activity every 5 minutes
    _activityTimer = Timer.periodic(_activityThreshold, (timer) {
      if (mounted) {
        _updateUserActivity();
      }
    });
  }

  void _updateUserActivity() {
    try {
      final authService = context.read<AuthService>();
      if (authService.isAuthenticated) {
        authService.updateActivity();
      }
    } catch (e) {
      // Ignore errors if context is not available
    }
  }

  // Call this method when user performs an action
  void onUserAction() {
    _updateUserActivity();
  }

  // Override this method to add custom activity tracking
  void onCustomUserAction() {
    onUserAction();
  }
}

// Mixin for pages that need activity tracking
mixin PageActivityMixin<T extends StatefulWidget> on State<T> {
  Timer? _pageActivityTimer;
  static const Duration _pageActivityThreshold = Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    _startPageActivityMonitoring();
  }

  @override
  void dispose() {
    _pageActivityTimer?.cancel();
    super.dispose();
  }

  void _startPageActivityMonitoring() {
    // Update activity more frequently for active pages
    _pageActivityTimer = Timer.periodic(_pageActivityThreshold, (timer) {
      if (mounted) {
        _updatePageActivity();
      }
    });
  }

  void _updatePageActivity() {
    try {
      final authService = context.read<AuthService>();
      if (authService.isAuthenticated) {
        authService.updateActivity();
      }
    } catch (e) {
      // Ignore errors if context is not available
    }
  }

  // Call this method when user interacts with the page
  void onPageInteraction() {
    _updatePageActivity();
  }
}

// Mixin for forms that need activity tracking
mixin FormActivityMixin<T extends StatefulWidget> on State<T> {
  void onFormInteraction() {
    try {
      final authService = context.read<AuthService>();
      if (authService.isAuthenticated) {
        authService.updateActivity();
      }
    } catch (e) {
      // Ignore errors if context is not available
    }
  }
}

// Mixin for scrollable content that needs activity tracking
mixin ScrollActivityMixin<T extends StatefulWidget> on State<T> {
  ScrollController? _scrollController;
  Timer? _scrollActivityTimer;
  static const Duration _scrollActivityThreshold = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _startScrollActivityMonitoring();
  }

  @override
  void dispose() {
    _scrollActivityTimer?.cancel();
    super.dispose();
  }

  void _startScrollActivityMonitoring() {
    _scrollActivityTimer = Timer.periodic(_scrollActivityThreshold, (timer) {
      if (mounted && _scrollController != null) {
        _updateScrollActivity();
      }
    });
  }

  void _updateScrollActivity() {
    try {
      final authService = context.read<AuthService>();
      if (authService.isAuthenticated) {
        authService.updateActivity();
      }
    } catch (e) {
      // Ignore errors if context is not available
    }
  }

  void onScroll() {
    _updateScrollActivity();
  }

  // Set the scroll controller for this mixin
  void setScrollController(ScrollController controller) {
    _scrollController = controller;
  }
}
