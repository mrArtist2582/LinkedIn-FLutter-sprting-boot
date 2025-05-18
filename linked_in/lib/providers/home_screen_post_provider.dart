import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomescreenPostProvider with ChangeNotifier {
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _jobs = [];
  List<Map<String, dynamic>> _searchResults = []; // Added searchResults

  List<Map<String, dynamic>> get posts => _posts;
  List<Map<String, dynamic>> get jobs => _jobs;
  List<Map<String, dynamic>> get searchResults =>
      _searchResults; // Getter for searchResults

  Future<void> fetchPosts() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    try {
      final response = await http.get(
        Uri.parse('http://192.168.105.153:8080/jobpost/get'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        _posts = data.cast<Map<String, dynamic>>();
        notifyListeners();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      throw Exception('Something went wrong: $error');
    }
  }

  Future<void> searchPosts(String keyword) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final url =
        Uri.parse('http://192.168.105.153:8080/jobpost/search?keyword=$keyword');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token'
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        //  print("Search result: ${data['posts']}");
        _searchResults = List<Map<String, dynamic>>.from(data['posts'] ?? []);
        _jobs = List<Map<String, dynamic>>.from(data['jobs'] ?? []);

        notifyListeners();
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }
}
