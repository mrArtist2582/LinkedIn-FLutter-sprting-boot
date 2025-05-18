import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linked_in/providers/post_provider.dart';
import 'package:provider/provider.dart';

class CreatePostCard extends StatefulWidget {
  final VoidCallback onPostCreated;

  const CreatePostCard({Key? key, required this.onPostCreated}) : super(key: key);

  @override
  State<CreatePostCard> createState() => _CreatePostCardState();
}

class _CreatePostCardState extends State<CreatePostCard> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  Uint8List? selectedImageBytes;
  String? selectedImageName;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    titleController.dispose();
    contentController.dispose();
    urlController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    if (_isDisposed) return;
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      if (_isDisposed) return;
      setState(() {
        selectedImageBytes = bytes;
        selectedImageName = image.name;
        urlController.text = image.name;
      });
    }
  }

  void submitPost() async {
    if (_isDisposed) return;
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final url = urlController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      _showSnackBar("Please enter both title and content.",
          backgroundColor: Colors.red);
      return;
    }

    final postProvider = Provider.of<PostProvider>(context, listen: false);

    try {
      await postProvider.createPost(
          title: title,
          content: content,
          url: url,
          imageBytes: selectedImageBytes);
      if (_isDisposed) return;
      widget.onPostCreated();
      _showSnackBar("Post created successfully!",
          backgroundColor: Colors.green); // Show success
      _clearInputFields();
    } catch (e) {
      if (_isDisposed) return;
      _showSnackBar('Failed to create post: $e',
          backgroundColor: Colors.red); // show error
    }
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    if (_isDisposed) return; // Check if the widget is disposed.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor ??
            Colors.grey, // Default background color if not provided
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      ),
    );
  }

  void _clearInputFields() {
    if (_isDisposed) return;
    titleController.clear();
    contentController.clear();
    urlController.clear();
    setState(() {
      selectedImageBytes = null;
      selectedImageName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PostProvider>().isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'), // Title for the AppBar
        automaticallyImplyLeading:
            false, // Remove the back button.  IMPORTANT
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // Added SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter post title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: theme.primaryColor, width: 2), // Highlight
                ),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Content',
                hintText: 'Write your post content here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: theme.primaryColor, width: 2), // Highlight
                ),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              keyboardType: TextInputType.url,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Image URL (Optional)',
                hintText: 'Enter image URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: theme.primaryColor, width: 2), // Highlight
                ),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            // ElevatedButton.icon(
            //   onPressed: pickImage,
            //   icon: Icon(Icons.add_photo_alternate,
            //       color: theme.colorScheme.primary),
            //   label: Text(
            //     "Add Photo",
            //     style: theme.textTheme.bodyMedium?.copyWith(
            //       color: theme.colorScheme.primary,
            //     ),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: theme.colorScheme.surfaceVariant,
            //     foregroundColor: theme.colorScheme.primary,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     padding: const EdgeInsets.symmetric(
            //         vertical: 12, horizontal: 16), // Increased padding
            //   ),
            // ),
            // if (selectedImageBytes != null)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 16.0),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(12),
            //       child: Image.memory(
            //         selectedImageBytes!,
            //         height: 150, // Increased height
            //         width: double.infinity,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            const SizedBox(height: 24), // Increased space before button
            SizedBox(
              width: double.infinity,
              height: 56, // Increased height
              child: ElevatedButton(
                onPressed: isLoading ? null : submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Post",
                      ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

