import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.105.153:8080/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Registration successful – do nothing here, handled in UI
      return;
    } else if (response.statusCode == 208) {
      throw Exception('Account already exists');
    } else {
      throw Exception('Failed to register');
    }

    // Successfully registered – no need to set isAuthenticated or user
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.105.153:8080/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);
      await prefs.setString('email', responseData['user']['email']);
      await prefs.setString('username', responseData['user']['username']);
      await prefs.setString('password', responseData['user']['password']);

      _isAuthenticated = true;
      notifyListeners();

      return {
        'email': responseData['user']['email'], // fixed this part too
        'token': responseData['token'],
      };
    } else if (response.statusCode == 401) {
      throw Exception('Invalid password');
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Login failed. Please try again.');
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
  }
}