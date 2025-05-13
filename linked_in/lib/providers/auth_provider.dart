import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;

  Future<void> login(String email, String password) async {
    // Mock login - in a real app, this would make an API call
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _user = {
      'id': '1',
      'name': 'John Doe',
      'email': email,
      'profilePicture': '',
      'headline': 'Software Developer',
      'about': 'Passionate about creating great software',
      'skills': ['Flutter', 'Dart', 'Firebase'],
    };
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    // Mock registration - in a real app, this would make an API call
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _user = {
      'id': '1',
      'name': name,
      'email': email,
      'profilePicture': '',
      'headline': 'New User',
      'about': '',
      'skills': [],
    };
    notifyListeners();
  }

  Future<void> logout() async {
    // Mock logout - in a real app, this would clear tokens
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
} 