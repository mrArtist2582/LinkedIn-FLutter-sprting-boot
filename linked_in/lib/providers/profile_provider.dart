import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  Map<String, dynamic>? _profile;
  bool _isLoading = false;
  final bool _isOwnProfile = true;

  ProfileProvider() {
    // Initialize with mock data for development
    _profile = {
      'name': 'John Doe',
      'headline': 'Software Engineer at Tech Company',
      'avatar': '',
      'location': 'New York, NY',
      'about': 'Passionate software engineer with 5 years of experience in mobile and web development. Specialized in Flutter and React Native.',
      'skills': [
        'Flutter',
        'Dart',
        'React Native',
        'JavaScript',
        'TypeScript',
        'Node.js',
      ],
      'experiences': [
        {
          'title': 'Senior Software Engineer',
          'company': 'Tech Company',
          'company_logo': 'https://via.placeholder.com/40',
          'start_date': 'Jan 2020',
          'end_date': 'Present',
          'description': 'Leading mobile app development team and implementing new features.',
        },
        {
          'title': 'Software Engineer',
          'company': 'Previous Company',
          'company_logo': 'https://via.placeholder.com/40',
          'start_date': 'Jun 2018',
          'end_date': 'Dec 2019',
          'description': 'Developed and maintained mobile applications.',
        },
      ],
      'education': [
        {
          'school': 'University of Technology',
          'degree': 'Bachelor of Science in Computer Science',
          'school_logo': 'https://via.placeholder.com/40',
          'start_date': '2014',
          'end_date': '2018',
          'description': 'Graduated with honors. Specialized in Software Engineering.',
        },
      ],
      'activities': [
        {
          'user_name': 'John Doe',
          'user_avatar': 'https://via.placeholder.com/40',
          'timestamp': '2 hours ago',
          'content': 'Just completed a new Flutter project! Check it out.',
          'image': 'https://via.placeholder.com/400x300',
        },
        {
          'user_name': 'John Doe',
          'user_avatar': 'https://via.placeholder.com/40',
          'timestamp': '1 day ago',
          'content': 'Attended the Flutter Conference 2024. Great experience!',
        },
      ],
    };
  }

  Map<String, dynamic>? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isOwnProfile => _isOwnProfile;

  Future<void> fetchProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      // In a real app, you would make an HTTP request here
      // For now, we're using mock data
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? headline,
    String? about,
    List<String>? skills,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (_profile != null) {
        if (headline != null) _profile!['headline'] = headline;
        if (about != null) _profile!['about'] = about;
        if (skills != null) _profile!['skills'] = skills;
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture(String imagePath) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (_profile != null) {
        _profile!['avatar'] = imagePath;
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSkill(String skill) async {
    if (_profile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      final skills = List<String>.from(_profile!['skills']);
      if (!skills.contains(skill)) {
        skills.add(skill);
        _profile!['skills'] = skills;
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeSkill(String skill) async {
    if (_profile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      final skills = List<String>.from(_profile!['skills']);
      skills.remove(skill);
      _profile!['skills'] = skills;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 