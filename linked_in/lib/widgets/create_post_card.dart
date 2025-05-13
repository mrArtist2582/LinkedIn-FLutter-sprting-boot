import 'package:flutter/material.dart';
import 'package:linked_in/providers/auth_provider.dart';

import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

class CreatePostCard extends StatefulWidget {
  final VoidCallback onPostCreated;

  const CreatePostCard({
    super.key,
    required this.onPostCreated,
  });

  @override
  State<CreatePostCard> createState() => _CreatePostCardState();
}

class _CreatePostCardState extends State<CreatePostCard> {
  final _contentController = TextEditingController();
  String? _imagePath;
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_contentController.text.isEmpty && _imagePath == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<PostProvider>(context, listen: false).createPost(
        _contentController.text,
      );

      _contentController.clear();
      setState(() {
        _imagePath = null;
      });

      widget.onPostCreated();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    Provider.of<AuthProvider>(context)
                            .user?['profilePicture'] ??
                        '',
                  ),
                  onBackgroundImageError: (_, __) {},
                  child: Provider.of<AuthProvider>(context)
                              .user?['profilePicture'] ==
                          null
                      ? Text(Provider.of<AuthProvider>(context)
                          .user?['name'][0]
                          .toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: 'Start a post...',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                ),
              ],
            ),
            if (_imagePath != null) ...[
              const SizedBox(height: 16),
              Stack(
                children: [
                  Image.network(
                    _imagePath!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _imagePath = null;
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: _isLoading ? null : _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Photo'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () {
                     
                          },
                    icon: const Icon(Icons.videocam),
                    label: const Text('Video'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () {
                         
                          },
                    icon: const Icon(Icons.article),
                    label: const Text('Document'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createPost,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Post'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
