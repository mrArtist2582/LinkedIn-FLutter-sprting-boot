import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Assuming you have a ProfileProvider.  If not, create one.
class ProfileProvider with ChangeNotifier {
  String? username;
  String? headline;
  String? city;
  String? country;
  String? about;
  String? skills;
  // Add lists for experience and education if you're managing them in the provider
  List<Map<String, String>> experienceList = [];
  List<Map<String, String>> educationList = [];

  // Example update methods.  Adjust as needed.
  void setUsername(String name) {
    username = name;
    notifyListeners();
  }

  void setHeadline(String newHeadline) {
    headline = newHeadline;
    notifyListeners();
  }

  void setLocation(String newCity, String newCountry) {
    city = newCity;
    country = newCountry;
    notifyListeners();
  }

  void setAbout(String newAbout) {
    about = newAbout;
    notifyListeners();
  }

  void setSkills(String newSkills) {
    skills = newSkills;
    notifyListeners();
  }

  void setExperience(List<Map<String, String>> newExperience) {
    experienceList = newExperience;
    notifyListeners();
  }

    void setEducation(List<Map<String, String>> newEducation) {
    educationList = newEducation;
    notifyListeners();
  }

  // Add a method to update all profile data at once, if needed
  void updateProfile({
    String? newUsername,
    String? newHeadline,
    String? newCity,
    String? newCountry,
    String? newAbout,
    String? newSkills,
        List<Map<String, String>>? newExperienceList,
    List<Map<String, String>>? newEducationList,
  }) {
    username = newUsername ?? username;
    headline = newHeadline ?? headline;
    city = newCity ?? city;
    country = newCountry ?? country;
    about = newAbout ?? about;
    skills = newSkills ?? skills;
        experienceList = newExperienceList ?? experienceList;
        educationList = newEducationList ?? educationList;
    notifyListeners();
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Profile fields (managed by ProfileProvider now)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();

  // Local lists for editing.  These will be saved to the provider.
  List<Map<String, String>> _educationList = [];
  List<Map<String, String>> _experienceList = [];
  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _nameController.text = profileProvider.username ?? '';
    _headlineController.text = profileProvider.headline ?? '';
    _locationController.text =
        '${profileProvider.city ?? ''}, ${profileProvider.country ?? ''}';
    _aboutController.text = profileProvider.about ?? '';
    _skills = profileProvider.skills?.split(',') ?? [];
        _educationList = profileProvider.educationList;
        _experienceList = profileProvider.experienceList;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _locationController.dispose();
    _aboutController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < getSteps().length - 1) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              _saveProfile();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          controlsBuilder: (context, details) {
            return Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xFF0077B5),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  onPressed: details.onStepContinue,
                  child: Text(
                    _currentStep == getSteps().length - 1
                        ? 'Finish'
                        : 'Continue',
                  ),
                ),
                const SizedBox(width: 15),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
              ],
            );
          },
          steps: getSteps(),
        ),
      ),
    );
  }

  List<Step> getSteps() => List.generate(5, (index) {
        return Step(
          title: _stepTitle(index),
          content: _stepContent(index),
          isActive: _currentStep >= index,
          state: _currentStep > index ? StepState.complete : StepState.indexed,
        );
      });

  Widget _stepTitle(int index) {
    switch (index) {
      case 0:
        return const Text('User Header');
      case 1:
        return const Text('About');
      case 2:
        return const Text('Experience');
      case 3:
        return const Text('Education');
      case 4:
        return const Text('Skills');
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _stepContent(int index) {
    switch (index) {
      case 0:
        final profileProvider = Provider.of<ProfileProvider>(context);
        return Column(
          children: [
            CircleAvatar(
                radius: 40,
                child: Text(profileProvider.username?[0].toUpperCase() ?? '')),
            const SizedBox(height: 8),
            _buildTextField(
              label: 'Name',
              controller: _nameController,
              onSaved: (val) {}, // Saving is done on Finish
            ),
            const SizedBox(height: 8),
            _buildTextField(
              label: 'Headline',
              controller: _headlineController,
              onSaved: (val) {}, // Saving is done on Finish
            ),
            const SizedBox(height: 8),
            _buildTextField(
              label: 'Location',
              controller: _locationController,
              onSaved: (val) {}, // Saving is done on Finish
            ),
          ],
        );
      case 1:
        return _buildTextField(
          label: 'About',
          controller: _aboutController,
          onSaved: (val) {}, // Saving is done on Finish
          maxLines: 5,
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._experienceList
                .map(
                  (exp) => ListTile(
                    title: Text(exp['title']!),
                    subtitle: Text(
                      '${exp['company']} - ${exp['start']} - ${exp['end']!.isNotEmpty ? exp['end'] : 'Present'}',
                    ),
                  ),
                )
                .toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: const Color(0xFF0077B5),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                _showAddExperienceDialog(context);
              },
              child: const Text('Add Experience'),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._educationList
                .map(
                  (edu) => ListTile(
                    title: Text(edu['college']!),
                    subtitle: Text(
                      '${edu['specialization']} (${edu['start']} - ${edu['end']})',
                    ),
                  ),
                )
                .toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showAddEducationDialog(context);
              },
              child: const Text('Add Education'),
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: _skills
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _skills.remove(skill);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _skillController,
                    decoration: const InputDecoration(
                      labelText: 'Add Skill',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    String newSkill = _skillController.text.trim();
                    if (newSkill.isNotEmpty && !_skills.contains(newSkill)) {
                      setState(() {
                        _skills.add(newSkill);
                        _skillController.clear();
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onSaved,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (val) =>
          val == null || val.isEmpty ? '$label cannot be empty' : null,
      onSaved: (val) => onSaved(val!),
    );
  }

  Future<void> _showAddExperienceDialog(BuildContext context) async {
    final formKeyExperience = GlobalKey<FormState>();
    TextEditingController companyController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();

    DateTime? startDate;
    DateTime? endDate;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Experience'),
          content: SingleChildScrollView(
            child: Form(
              key: formKeyExperience,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Company name cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Job Role',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Job role cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      startDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (startDate != null) {
                        startDateController.text =
                            DateFormat('yyyy').format(startDate!);
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Start date cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: endDateController,
                    decoration: const InputDecoration(
                      labelText: 'End Date (Leave empty if current)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      endDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (endDate != null) {
                        endDateController.text =
                            DateFormat('yyyy').format(endDate!);
                      }
                    },
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          startDate != null &&
                          endDate != null &&
                          endDate!.isBefore(startDate!)) {
                        return 'End date cannot be before start date';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (formKeyExperience.currentState!.validate()) {
                  setState(() {
                    _experienceList.add({
                      'company': companyController.text,
                      'title': titleController.text,
                      'start': startDateController.text,
                      'end': endDateController.text,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddEducationDialog(BuildContext context) async {
    final formKeyEducation = GlobalKey<FormState>();
    TextEditingController collegeController = TextEditingController();
    TextEditingController specializationController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();

    DateTime? startDate;
    DateTime? endDate;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Education'),
          content: SingleChildScrollView(
            child: Form(
              key: formKeyEducation,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: collegeController,
                    decoration: const InputDecoration(
                      labelText: 'College Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'College name cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: specializationController,
                    decoration: const InputDecoration(
                      labelText: 'Specialization',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Specialization cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      startDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (startDate != null) {
                        startDateController.text =
                            DateFormat('yyyy').format(startDate!);
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Start date cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: endDateController,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      endDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (endDate != null) {
                        endDateController.text =
                            DateFormat('yyyy').format(endDate!);
                      }
                    },
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          startDate != null &&
                          endDate != null &&
                          endDate!.isBefore(startDate!)) {
                        return 'End date cannot be before start date';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (formKeyEducation.currentState!.validate()) {
                  setState(() {
                    _educationList.add({
                      'college': collegeController.text,
                      'specialization': specializationController.text,
                      'start': startDateController.text,
                      'end': endDateController.text,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // No need to call _formKey.currentState!.save() here as we are using controllers

      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

      // Prepare the data to update
      profileProvider.updateProfile(
        newUsername: _nameController.text.trim(),
        newHeadline: _headlineController.text.trim(),
        newCity: _locationController.text.split(',').first.trim(),
        newCountry: _locationController.text.split(',').last.trim(),
        newAbout: _aboutController.text.trim(),
        newSkills: _skills.join(','), // Convert list to comma-separated string
        newExperienceList: _experienceList,
        newEducationList: _educationList,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));

      Navigator.pop(context);
      //  Removed the direct navigation to HomeScreen.  The calling widget should handle navigation.
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
    }
  }
}

