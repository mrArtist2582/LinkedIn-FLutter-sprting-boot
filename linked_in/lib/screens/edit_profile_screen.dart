import 'package:flutter/material.dart';
import 'package:linked_in/screens/profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              
             
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}