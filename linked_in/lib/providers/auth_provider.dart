import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    // Reset the error message before trying to log in
    _errorMessage = null;
    notifyListeners();

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email and password cannot be empty.';
      notifyListeners();
      return;
    }

    // Mock login - simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Simulate checking email and password
      if (email == 'test@example.com' && password == 'password') {
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
      } else {
        _errorMessage = 'Invalid email or password.';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Login failed. Please try again later.';
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    // Reset the error message before trying to register
    _errorMessage = null;
    notifyListeners();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'All fields are required.';
      notifyListeners();
      return;
    }

    // Mock registration - simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Simulate successful registration
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
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again later.';
      notifyListeners();
    }
  }

  Future<void> logout() async {
    // Mock logout - simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
}
