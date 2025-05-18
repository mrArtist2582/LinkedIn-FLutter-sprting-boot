import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobProvider with ChangeNotifier {
  List<Map<String, dynamic>> _jobs = [];
  final List<Map<String, dynamic>> _appliedJobs = [];

  List<Map<String, dynamic>> get jobs => [..._jobs];
  List<Map<String, dynamic>> get appliedJobs => [..._appliedJobs];

  Future<void> fetchJobs() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final url = Uri.parse('http://192.168.105.153:8080/job/get');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token'
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _jobs = data.map((job) => job as Map<String, dynamic>).toList();
        
        notifyListeners();
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (error) {
      print('Error fetching jobs: $error');
    }
  }

  Future<void> searchJobs(String keyword) async {
    final url =
        Uri.parse('http://192.168.105.153:8080/jobpost/search?keyword=$keyword');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _jobs = data.cast<Map<String, dynamic>>();
        notifyListeners();
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  void applyForJob(Map<String, dynamic> job) {
    if (!_appliedJobs.any((appliedJob) => appliedJob['id'] == job['id'])) {
      _appliedJobs.add(job);
      _jobs.removeWhere((j) => j['id'] == job['id']);
      notifyListeners();
      
    }
  }

  void removeAppliedJob(Map<String, dynamic> job) {
    _appliedJobs.removeWhere((appliedJob) => appliedJob['id'] == job['id']);
    _jobs.insert(0, job); 
    notifyListeners();
 
  }
}