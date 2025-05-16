import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linked_in/screens/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Profile fields
  String name = 'John Doe';
  String headline = 'Flutter Developer at KD Tech';
  String location = 'Ahmedabad, India';
  String about =
      'Creative and passionate Flutter developer with experience building beautiful mobile apps.';
  String email = 'john.doe@example.com';
  String phone = '+91 9876543210';
  String website = 'https://johndoe.dev';
  String activity = 'Posted an article on Flutter best practices';
  List<Map<String, String>> educationList = [
    {
      'college': 'MBIT College',
      'specialization': 'Computer Engineering',
      'start': '',
      'end': '',
    },
  ];
  List<Map<String, String>> experienceList = [
    {
      'company': 'KD Tech',
      'title': 'Flutter Developer',
      'start': '2022',
      'end': 'Present',
    },
    {'company': 'Internpe', 'title': 'Intern', 'start': '2021', 'end': ''},
  ];
  List<String> skills = ['Flutter', 'Firebase', 'Dart'];
  final TextEditingController _skillController = TextEditingController();

  @override
  void dispose() {
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
                    padding: EdgeInsets.symmetric(vertical: 20),
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

  List<Step> getSteps() => List.generate(6, (index) {
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
      case 5:
        return const Text('Contact & Activity');
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _stepContent(int index) {
    switch (index) {
      case 0:
        return Column(
          children: [
            CircleAvatar(radius: 40, child: Text(name[0])),
            const SizedBox(height: 8),
            _buildTextField(
              label: 'Name',
              initialValue: name,
              onSaved: (val) => name = val,
            ),
            const SizedBox(height: 8),
            _buildTextField(
              label: 'Headline',
              initialValue: headline,
              onSaved: (val) => headline = val,
            ),
            const SizedBox(height: 8),
            _buildTextField(
              label: 'Location',
              initialValue: location,
              onSaved: (val) => location = val,
            ),
          ],
        );
      case 1:
        return _buildTextField(
          label: 'About',
          initialValue: about,
          onSaved: (val) => about = val,
          maxLines: 5,
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...experienceList
                .map(
                  (exp) => ListTile(
                    title: Text(exp['title']!),
                    subtitle: Text(
                      '${exp['company']} - ${exp['start']} - ${exp['end']!.isNotEmpty ? exp['end'] : 'Present'}',
                    ),
                  ),
                )
                // ignore: unnecessary_to_list_in_spreads
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
            ...educationList.map(
              (edu) => ListTile(
                title: Text(edu['college']!),
                subtitle: Text(
                  '${edu['specialization']} (${edu['start']} - ${edu['end']})',
                ),
              ),
            ),
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
              children: skills
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          skills.remove(skill);
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
                    if (newSkill.isNotEmpty && !skills.contains(newSkill)) {
                      setState(() {
                        skills.add(newSkill);
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
      case 5:
        return Column(
          children: [
            _buildTextField(
              label: 'Email',
              initialValue: email,
              onSaved: (val) => email = val,
            ),
            const SizedBox(height: 8),
            _buildTextField(
              label: 'Phone',
              initialValue: phone,
              onSaved: (val) => phone = val,
            ),
            const SizedBox(height: 8),
            _buildTextField(
              label: 'Website',
              initialValue: website,
              onSaved: (val) => website = val,
            ),
            const SizedBox(height: 8),
            _buildTextField(
              label: 'Activity',
              initialValue: activity,
              onSaved: (val) => activity = val,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onSaved,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
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
                        startDateController.text = DateFormat(
                          'yyyy',
                        ).format(startDate!);
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
                        endDateController.text = DateFormat(
                          'yyyy',
                        ).format(endDate!);
                      }
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
                    experienceList.add({
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
                        startDateController.text = DateFormat(
                          'yyyy',
                        ).format(startDate!);
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
                        endDateController.text = DateFormat(
                          'yyyy',
                        ).format(endDate!);
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
                    educationList.add({
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

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}
