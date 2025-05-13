import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    setState(() {
      profileData = {
        'name': 'John Doe',
        'headline': 'Software Engineer at Tech Company',
        'avatar': '',
        'location': 'New York, NY',
        'about':
            'Passionate software engineer with 5 years of experience in mobile and web development. Specialized in Flutter and React Native.',
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
            'description':
                'Leading mobile app development team and implementing new features.',
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
            'degree': 'B.Sc. in Computer Science',
            'school_logo': 'https://via.placeholder.com/40',
            'start_date': '2014',
            'end_date': '2018',
            'description':
                'Graduated with honors. Specialized in Software Engineering.',
          },
        ],
        'activities': [
          {
            'user_name': 'John Doe',
            'user_avatar': 'https://via.placeholder.com/40',
            'timestamp': '2 hours ago',
            'content': 'Just completed a new Flutter project! Check it out.',
            'image':
                'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?auto=format&fit=crop&w=800&q=80',
          },
          {
            'user_name': 'John Doe',
            'user_avatar': 'https://via.placeholder.com/40',
            'timestamp': '1 day ago',
            'content':
                'Attended the Flutter Conference 2024. Great experience!',
          },
        ],
      };
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || profileData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              name: profileData!['name'] ?? '',
              headline: profileData!['headline'] ?? '',
              avatar: profileData!['avatar'] ?? '',
              location: profileData!['location'] ?? '',
              isOwnProfile: true,
            ),
            const SizedBox(height: 16),
            AboutSection(
              about: profileData!['about'] ?? '',
              isOwnProfile: true,
            ),
            const SizedBox(height: 16),
            ExperienceSection(
              experiences: List<Map<String, dynamic>>.from(
                profileData!['experiences'] ?? [],
              ),
              isOwnProfile: true,
            ),
            const SizedBox(height: 16),
            EducationSection(
              education: List<Map<String, dynamic>>.from(
                profileData!['education'] ?? [],
              ),
              isOwnProfile: true,
            ),
            const SizedBox(height: 16),
            SkillsSection(
              skills: List<String>.from(profileData!['skills'] ?? []),
              isOwnProfile: true,
            ),
            const SizedBox(height: 16),
            ActivitySection(
              activities: List<Map<String, dynamic>>.from(
                profileData!['activities'] ?? [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== UI Widgets Below ==========

class ProfileHeader extends StatelessWidget {
  final String name, headline, avatar, location;
  final bool isOwnProfile;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.headline,
    required this.avatar,
    required this.location,
    required this.isOwnProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
          child: avatar.isEmpty ? const Icon(Icons.person) : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(headline),
              Text(location, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

class AboutSection extends StatelessWidget {
  final String about;
  final bool isOwnProfile;

  const AboutSection({
    super.key,
    required this.about,
    required this.isOwnProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(about),
      ],
    );
  }
}

class ExperienceSection extends StatelessWidget {
  final List<Map<String, dynamic>> experiences;
  final bool isOwnProfile;

  const ExperienceSection({
    super.key,
    required this.experiences,
    required this.isOwnProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Experience',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...experiences.map((exp) {
          return ListTile(
            leading: Image.network(exp['company_logo'], width: 40, height: 40),
            title: Text(exp['title']),
            subtitle: Text(
              '${exp['company']} • ${exp['start_date']} - ${exp['end_date']}\n${exp['description']}',
            ),
          );
        }),
      ],
    );
  }
}

class EducationSection extends StatelessWidget {
  final List<Map<String, dynamic>> education;
  final bool isOwnProfile;

  const EducationSection({
    super.key,
    required this.education,
    required this.isOwnProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Education',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...education.map((edu) {
          return ListTile(
            leading: Image.network(edu['school_logo'], width: 40, height: 40),
            title: Text(edu['degree']),
            subtitle: Text(
              '${edu['school']} • ${edu['start_date']} - ${edu['end_date']}\n${edu['description']}',
            ),
          );
        }),
      ],
    );
  }
}

class SkillsSection extends StatelessWidget {
  final List<String> skills;
  final bool isOwnProfile;

  const SkillsSection({
    super.key,
    required this.skills,
    required this.isOwnProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Skills',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: skills.map((skill) => Chip(label: Text(skill))).toList(),
        ),
      ],
    );
  }
}

class ActivitySection extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const ActivitySection({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activity',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...activities.map((activity) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(activity['user_avatar']),
              ),
              title: Text(activity['user_name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity['timestamp']),
                  Text(activity['content']),
                  if (activity.containsKey('image'))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.network(activity['image']),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
