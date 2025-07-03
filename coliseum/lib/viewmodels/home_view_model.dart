import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/services/post_service.dart';
import 'package:flutter/material.dart';

enum ViewState { idle, loading, error }

class HomeViewModel extends ChangeNotifier {
  final PostService _postService;

  HomeViewModel(this._postService);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _setState(ViewState.loading);
    try {
      _posts = await _postService.getFeedPosts();
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