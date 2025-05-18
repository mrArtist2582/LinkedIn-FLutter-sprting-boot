import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  // Auth info
  String? _username;
  String? _email;
  String? _token;

  // Profile info
  String? headline;
  String? skills;
  String? education;
  String? country;
  String? city;
  String? about;
  String? pronouns;
  String? link;
  String? linkText;
  String? industry;
  String? experience;

  bool isLoading = false;
  bool isfetch = false;

  // Getters
  String? get username => _username;
  String? get email => _email;
  String? get token => _token;

  List<Map<String, dynamic>> userPosts = [];
  bool isPostLoading = false;

  // Load auth info from SharedPreferences
  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _email = prefs.getString('email');
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    if (_token == null) {
      await loadProfileData(); // Ensure token is loaded
    }

    final url = Uri.parse('http://192.168.105.153:8080/profile/get');

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(url, headers: {
        'Authorization': '$_token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        headline = data['headline'];
        skills = data['skills'];
        education = data['education'];
        country = data['country'];
        city = data['city'];
        about = data['about'];
        pronouns = data['pronoums'];
        link = data['link'];
        linkText = data['linktext'];
        industry = data['industry'];
        experience = data['experience'];

        isfetch = true;
      } else {
        print("No profile found");
      }
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> body) async {
    if (_token == null) {
      await loadProfileData();
    }

    final Uri url = isfetch
        ? Uri.parse('http://192.168.105.153:8080/profile/update') // Update existing
        : Uri.parse('http://192.168.105.153:8080/profile/post'); // Create new

    try {
      final response = isfetch
          ? await http.put(
              url,
              headers: {
                'Authorization': '$_token',
                'Content-Type': 'application/json',
              },
              body: json.encode(body),
            )
          : await http.post(
              url,
              headers: {
                'Authorization': '$_token',
                'Content-Type': 'application/json',
              },
              body: json.encode(body),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchProfile(); // Refresh profile after save/update
        print("Profile saved/updated successfully");
      } else {
        print("Save/Update failed: ${response.body}");
      }
    } catch (e) {
      print("Save/Update error: $e");
    }
  }

  Future<void> deleteprofile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> fetchUserPosts() async {
    if (_token == null) {
      await loadProfileData(); // Ensure token is available
    }

    final url = Uri.parse('http://192.168.105.153:8080/jobpost/get');

    try {
      isPostLoading = true;
      notifyListeners();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$_token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        userPosts = data.cast<Map<String, dynamic>>();
      } else {
        print("Failed to fetch posts: ${response.body}");
      }
    } catch (e) {
      print("Error fetching posts: $e");
    } finally {
      isPostLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePost(int postId, Map<String, dynamic> updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.put(
        Uri.parse('http://192.168.105.153:8080/jobpost/update/$postId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        // Update the post locally as well, if needed
        int index = userPosts.indexWhere((post) => post['id'] == postId);
        if (index != -1) {
          userPosts[index] = {...userPosts[index], ...updatedData};
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  Future<void> deletePost(int postId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    try {
      // Assume you have an HTTP service to delete post
      final response = await http.delete(
          Uri.parse('http://192.168.105.153:8080/jobpost/delete/$postId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$token',
          });

      if (response.statusCode == 200) {
        // Remove the post from local list
        userPosts.removeWhere((post) => post['id'] == postId);
        notifyListeners();
        await fetchUserPosts();
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      print('Error deleting post: $e');
      // Optionally show error in UI
    }
  }

}