import 'package:flutter/material.dart';
import 'package:linked_in/providers/comment_provider.dart';
import 'package:provider/provider.dart';

//  Change the return type of the function to Future<int?>.
Future<int?> openCommentsBottomSheet(
    BuildContext context, Map<String, dynamic> item) async {
  final TextEditingController commentController = TextEditingController();
  final int postId = item['id'];
  final commentProvider = Provider.of<CommentProvider>(context, listen: false);

  final updatedComments = await showModalBottomSheet<List<dynamic>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: FutureBuilder<List<dynamic>>(
          future: commentProvider.getComments(postId), // 🔁 FETCH from backend
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Failed to load comments."));
            }

            List<dynamic> comments = snapshot.data ?? [];

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Comments',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    comments.isEmpty
                        ? const Text('No comments yet.')
                        : SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                return ListTile(
                                  leading: const Icon(Icons.comment),
                                  title: Text(comment.toString()),
                                );
                              },
                            ),
                          ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: 'Write a comment...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            final comment = commentController.text.trim();
                            if (comment.isNotEmpty) {
                              final success = await commentProvider.postComment(
                                postId: postId,
                                commentText: comment,
                              );

                              if (success) {
                                setModalState(() {
                                  comments.add(comment); // or re-fetch list
                                });
                                commentController.clear();
                                FocusScope.of(context).unfocus();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Failed to post comment.')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        //  Pass the comments back to the caller.
                        Navigator.pop(context, comments);
                      },
                      child: const Text("Done"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );

  //  Return the number of comments if updatedComments is not null.  Important
  if (updatedComments != null) {
    return updatedComments.length;
  }
  // Return null if updatedComments is null.  Important
  return null;
}

