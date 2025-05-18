import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentProvider with ChangeNotifier {
  Future<bool> postComment({
    required int postId,
    required String commentText,
  }) async {
    final url = Uri.parse('http://192.168.105.153:8080/post/$postId/comments');
    print(postId);
    print(commentText);

    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: jsonEncode({'text': commentText}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      debugPrint('Failed to post comment: ${response.body}');
      return false;
    }
  }

  Future<List<dynamic>> getComments(int postId) async {
    final url = Uri.parse('http://192.168.105.153:8080/post/$postId/comments');
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        print("Failed to fetch comments: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching comments: $e");
      return [];
    }
  }
}