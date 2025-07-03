import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/services/mock_post_service.dart';
import 'package:coliseum/services/post_service.dart';
import 'package:flutter/material.dart';

enum SavedState { idle, loading, success, error }

class SavedViewModel extends ChangeNotifier {
  final PostService _postService = MockPostService();

  SavedState _state = SavedState.idle;
  SavedState get state => _state;

  List<Post> _allPosts = [];
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Post> get savedPosts => _allPosts.where((post) => post.isFavorited).toList();

  Future<void> fetchPosts() async {
    _state = SavedState.loading;
    notifyListeners();

    try {
      _allPosts = await _postService.getFeedPosts();
      _state = SavedState.success;
    } catch (e) {
      _state = SavedState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
} 