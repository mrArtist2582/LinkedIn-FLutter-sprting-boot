
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:linked_in/widgets/create_post_card.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CreatePostCard(
          onPostCreated: () {
            // Pop the screen after post creation
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
