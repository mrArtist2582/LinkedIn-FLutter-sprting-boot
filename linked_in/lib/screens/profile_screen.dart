import 'package:flutter/material.dart';
import 'package:linked_in/providers/profile_provider.dart';
import 'package:linked_in/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:linked_in/widgets/see_all_post.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.loadProfileData().then((_) {
      profileProvider.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Use theme's background
      body: profileProvider.username == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Section
                  Container(
                    padding: const EdgeInsets.only(
                        top: 24, left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: theme.primaryColor, // Use primary color for header
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: Text(
                                  profileProvider.username!.isNotEmpty
                                      ? profileProvider.username![0].toUpperCase()
                                      : '',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            _buildEditDialog(context),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.white, // White edit icon background
                                      radius: 20,
                                      child: Icon(
                                        Icons.edit,
                                        color: theme.primaryColor, // Primary color icon
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            _buildDeleteDialog(context),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.white, // White logout background
                                      radius: 20,
                                      child: Icon(
                                        Icons.logout_outlined,
                                        color: theme.primaryColor, // Primary color icon
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            profileProvider.username ?? 'No Name',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profileProvider.headline ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${profileProvider.country ?? ''}, ${profileProvider.city ?? ''}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          //Added styling,
                          if (profileProvider.link != null &&
                              profileProvider.link!.isNotEmpty)
                            Text(
                              profileProvider.link ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            profileProvider.industry ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // About Section
                  _buildSection(
                    context,
                    'About',
                    profileProvider.about ?? 'Add About your Technologies',
                  ),
                  // Experience Section
                  _buildSection(
                    context,
                    'Experience',
                    profileProvider.experience ?? 'Add Experience',
                  ),
                  // Education Section
                  _buildSection(
                    context,
                    'Education',
                    profileProvider.education ?? 'Add Education',
                  ),
                  // Skills Section
                  _buildSection(
                    context,
                    'Skills',
                    profileProvider.skills ?? 'Add Skills',
                  ),
                  PostsFeed(),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (title == "Skills")
            (content.trim().isEmpty
                ? Text(
                    'No skills added yet.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey), //Consistent theme
                  ) // kuch bhi show nahi karega jab skills empty ho
                : Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: content
                        .split(',')
                        .where((skill) =>
                            skill.trim().isNotEmpty) // empty skill hatao
                        .map((skill) => Chip(
                              label: Text(
                                skill.trim(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: theme
                                  .primaryColor, // Use the theme's primary color
                            ))
                        .toList(),
                  ))
          else
            Text(
              content,
              style: theme.textTheme.bodyMedium, // Use bodyMedium for consistent styling
            ),
          const Divider(
            height: 24,
            thickness: 1,
          ), // Added divider for visual separation
        ],
      ),
    );
  }

  Widget _buildEditDialog(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    // ignore: unused_local_variable
    final nameController =
        TextEditingController(text: profileProvider.username ?? '');
    final industryController =
        TextEditingController(text: profileProvider.industry ?? '');
    final skillsController =
        TextEditingController(text: profileProvider.skills ?? '');
    final headlineController =
        TextEditingController(text: profileProvider.headline ?? '');
    final educationController =
        TextEditingController(text: profileProvider.education ?? '');
    final locationController =
        TextEditingController(text: profileProvider.country ?? '');
    final cityController =
        TextEditingController(text: profileProvider.city ?? '');
    final aboutController =
        TextEditingController(text: profileProvider.about ?? '');
    final linkController =
        TextEditingController(text: profileProvider.link ?? '');
    final linkTextController =
        TextEditingController(text: profileProvider.linkText ?? '');
    String selectedPronoun = profileProvider.pronouns ?? 'They/Them';

    final pronouns = ['He/Him', 'She/Her', 'They/Them', 'Other'];
    final experienceController =
        TextEditingController(text: profileProvider.experience ?? '');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text("Edit intro",
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: headlineController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  hintText: 'Headline',
                  border: OutlineInputBorder(),
                  labelText: "Headline*"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: industryController,
              decoration: const InputDecoration(
                labelText: 'Industry*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Education", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextFormField(
              controller: educationController,
              decoration: const InputDecoration(
                labelText: 'School/College*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Country*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedPronoun,
              items: pronouns.map((String pronoun) {
                return DropdownMenuItem<String>(
                  value: pronoun,
                  child: Text(pronoun),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) selectedPronoun = newValue;
              },
              decoration: const InputDecoration(
                labelText: 'Pronouns',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Website", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextFormField(
              controller: linkController,
              decoration: const InputDecoration(
                labelText: 'Link',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: linkTextController,
              decoration: const InputDecoration(
                labelText: 'Link Text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: experienceController,
              decoration: const InputDecoration(
                labelText: 'Experience',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: aboutController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  hintText: 'About',
                  border: OutlineInputBorder(),
                  labelText: "About"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            // Prepare data from controllers
            Map<String, dynamic> body = {
              "headline": headlineController.text.trim(),
              "skills": skillsController.text.trim(),
              "education": educationController.text.trim(),
              "country": locationController.text.trim(),
              "city": cityController.text.trim(),
              "about": aboutController.text.trim(),
              "pronouns": selectedPronoun,
              "link": linkController.text.trim(),
              "linkText": linkTextController.text.trim(),
              "industry": industryController.text.trim(),
              "experience": experienceController.text.trim()
            };

            await profileProvider.updateProfile(body);
            Navigator.of(context).pop();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }

  Widget _buildDeleteDialog(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    return AlertDialog(
      title: const Text("Logout"),
      content: const Text(
          "If you want to logout then press Yes, or press Cancel to stay."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await profileProvider.deleteprofile(); // Handle logout logic
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}

