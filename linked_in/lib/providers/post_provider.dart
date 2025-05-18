import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PostProvider with ChangeNotifier {
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;

  List<Map<String, dynamic>> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _posts = [];
      _hasMore = true;
    }

    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('YOUR_API_URL/posts?page=$_currentPage'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newPosts = List<Map<String, dynamic>>.from(data['posts']);

        if (newPosts.isEmpty) {
          _hasMore = false;
        } else {
          _posts.addAll(newPosts);
          _currentPage++;
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updated createPost to accept title, content, and url
  Future<void> createPost({
    required String title,
    required String content,
    required String url, Uint8List? imageBytes,
  }) async {
    _isLoading = true;
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    try {
      final response = await http.post(
        Uri.parse('http://192.168.105.153:8080/jobpost/post'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token'
        },
        body: json.encode({
          'title': title,
          'content': content,
          'url': url,
        }),
      );

      if (response.statusCode == 200) {
        final newPost = json.decode(response.body);
        _posts.insert(0, newPost);
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final response = await http.post(
        Uri.parse('YOUR_API_URL/posts/$postId/like'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final index = _posts.indexWhere((post) => post['id'] == postId);
        if (index != -1) {
          _posts[index]['likes'] = (_posts[index]['likes'] as int) + 1;
          _posts[index]['isLiked'] = true;
          notifyListeners();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('YOUR_API_URL/posts/$postId/like'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final index = _posts.indexWhere((post) => post['id'] == postId);
        if (index != -1) {
          _posts[index]['likes'] = (_posts[index]['likes'] as int) - 1;
          _posts[index]['isLiked'] = false;
          notifyListeners();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addComment(String postId, String content) async {
    try {
      final response = await http.post(
        Uri.parse('YOUR_API_URL/posts/$postId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 201) {
        final newComment = json.decode(response.body);
        final index = _posts.indexWhere((post) => post['id'] == postId);
        if (index != -1) {
          _posts[index]['comments'].add(newComment);
          notifyListeners();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('YOUR_API_URL/posts/$postId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _posts.removeWhere((post) => post['id'] == postId);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}