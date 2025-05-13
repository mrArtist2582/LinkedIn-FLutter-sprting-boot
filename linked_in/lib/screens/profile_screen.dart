import 'package:flutter/material.dart';
import 'package:linked_in/screens/edit_profile_screen.dart';

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const EditProfileScreen(),
            ));
          },
        ),
      ],),
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
    // If avatar is empty, use the first letter of the user's name
    String displayAvatar = avatar.isNotEmpty ? avatar : name[0];

    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
          child: avatar.isEmpty
              ? Text(
                  displayAvatar,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        const Text(
          'About',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
        const Text(
          'Experience',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...experiences.map((exp) {
          return ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  exp['company_logo'] != null &&
                      exp['company_logo'].toString().isNotEmpty
                  ? NetworkImage(exp['company_logo'])
                  : null,
              onBackgroundImageError: (_, __) {}, // avoid crash if image fails
              child:
                  (exp['company_logo'] == null ||
                      exp['company_logo'].toString().isEmpty)
                  ? Text(
                      exp['company'] != null &&
                              exp['company'].toString().isNotEmpty
                          ? exp['company'][0].toUpperCase()
                          : '?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            title: Text(exp['title'] ?? ''),
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
        const Text(
          'Education',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...education.map((edu) {
          final schoolLogo = edu['school_logo'] ?? '';
          final schoolName = edu['school'] ?? '';
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: schoolLogo.isNotEmpty
                ? SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.network(
                      schoolLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          radius: 20,
                          child: Text(
                            schoolName.isNotEmpty ? schoolName[0].toUpperCase() : '?',
                          ),
                        );
                      },
                    ),
                  )
                : CircleAvatar(
                    radius: 20,
                    child: Text(
                      schoolName.isNotEmpty ? schoolName[0].toUpperCase() : '?',
                    ),
                  ),
            title: Text(
              edu['degree'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '$schoolName • ${edu['start_date']} - ${edu['end_date']}\n${edu['description']}',
            ),
            isThreeLine: true,
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
        const Text(
          'Skills',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...activities.map((activity) {
          final avatarUrl = activity['user_avatar'] ?? '';
          final userName = activity['user_name'] ?? '';
          final timestamp = activity['timestamp'] ?? '';
          final content = activity['content'] ?? '';
          final postImage = activity['image'];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row: Avatar + Name + Timestamp
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(avatarUrl),
                      onBackgroundImageError: (_, __) => const Icon(Icons.person),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            timestamp,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// Post Content
                Text(
                  content,
                  style: const TextStyle(fontSize: 14),
                ),

                /// Optional Image
                if (postImage != null && postImage.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      postImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Text('Image failed to load'),
                    ),
                  ),
                ],
              ],
            ),
          );
        // ignore: unnecessary_to_list_in_spreads
        }).toList(),
      ],
    );
  }
}
