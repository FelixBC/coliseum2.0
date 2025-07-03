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
    _setState(ViewState.loading);
    try {
      // Fetch profile and posts in parallel
      final futureUser = _userService.getUserProfile(userId);
      final futurePosts = _userService.getUserPosts(userId);

      _user = await futureUser;
      _posts = await futurePosts;

    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
      return;
    }
    _setState(ViewState.idle);
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
    _state = newState;
    notifyListeners();
  }
} 