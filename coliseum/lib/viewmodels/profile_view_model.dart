import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/user_service.dart';
import 'package:coliseum/viewmodels/home_view_model.dart'; // Reusing ViewState
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserService _userService;

  ProfileViewModel(this._userService);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  User? _user;
  User? get user => _user;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchUserProfile(String userId) async {
    // Prevent multiple simultaneous fetches for the same user
    if (_state == ViewState.loading && _user?.id == userId) {
      return;
    }
    
    _setState(ViewState.loading);
    try {
      // Fetch profile and posts in parallel
      final futureUser = _userService.getUserProfile(userId);
      final futurePosts = _userService.getUserPosts(userId);

      final newUser = await futureUser;
      final newPosts = await futurePosts;

      // Only update if data actually changed
      if (_user?.id != newUser.id || _posts.length != newPosts.length) {
        _user = newUser;
        _posts = newPosts;
        _setState(ViewState.idle);
      } else {
        _setState(ViewState.idle);
      }

    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
      return;
    }
  }

  Future<void> updateProfile(User updatedUser) async {
    _setState(ViewState.loading);
    try {
      _user = await _userService.updateUserProfile(updatedUser);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
      return;
    }
    _setState(ViewState.idle);
  }

  void _setState(ViewState newState) {
    // Only update state if it actually changed
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
} 