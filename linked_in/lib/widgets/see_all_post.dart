import 'package:flutter/material.dart';
import 'package:linked_in/providers/profile_provider.dart';

import 'package:provider/provider.dart';

class PostsFeed extends StatefulWidget {
  @override
  _PostsFeedState createState() => _PostsFeedState();
}

class _PostsFeedState extends State<PostsFeed> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchUserPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.isPostLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final posts = profileProvider.userPosts;

        if (posts.isEmpty) {
          return Center(child: Text('No posts found.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Text(
                'Activity',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Posts List
            Container(
              height: 500,
              padding: EdgeInsets.symmetric(vertical: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemCount: posts.length,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final post = posts[index];

                  final user = post['user'] ?? {};
                  final userName = user['username'] ?? 'Unknown';
                  final headline = user['email'] ?? '';
                  final date = post['createAt'] != null
                      ? post['createAt'].toString().substring(0, 10)
                      : '';
                  final avatar =
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?';
                  final content = post['content'] ?? '';
                  final image = post['url'] ?? '';
                  final int likes = post['likes'] ?? 0;
                  final int comments = post['comments'] ?? 0;
                  final bool liked = post['liked'] ?? false;

                  return Container(
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 3)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                child: Text(
                                  avatar,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                radius: 22,
                                backgroundColor: Colors.blue,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      headline,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '$date • 🌐',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    print(
                                        'Edit clicked for post: ${post['id']}');

                                    // Example: Show dialog or screen to edit content, here I just simulate update
                                    final updatedContent =
                                        await showDialog<String>(
                                      context: context,
                                      builder: (context) {
                                        String newContent =
                                            post['content'] ?? '';
                                        return AlertDialog(
                                          title: Text("Edit Post"),
                                          content: TextField(
                                            onChanged: (val) =>
                                                newContent = val,
                                            controller: TextEditingController(
                                                text: post['content']),
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Update your post content"),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () =>
                                                  Navigator.pop(context, null),
                                            ),
                                            TextButton(
                                              child: Text("Update"),
                                              onPressed: () => Navigator.pop(
                                                  context, newContent),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (updatedContent != null &&
                                        updatedContent.trim().isNotEmpty) {
                                      // Call updatePost in ProfileProvider with post ID and updated content
                                      await Provider.of<ProfileProvider>(
                                              context,
                                              listen: false)
                                          .updatePost(
                                        post[
                                            'id'], // Make sure postId is string for backend
                                        {'content': updatedContent.trim()},
                                      );
                                    }
                                  } else if (value == 'delete') {
                                    final shouldDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Delete Post"),
                                        content: Text(
                                            "Are you sure you want to delete this post?"),
                                        actions: [
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                          ),
                                          TextButton(
                                            child: Text("Delete",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (shouldDelete == true) {
                                      Provider.of<ProfileProvider>(context,
                                              listen: false)
                                          .deletePost(post['id']);
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 18),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 18),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                                icon: Icon(Icons.more_horiz),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            content,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          if (image.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(child: Icon(Icons.broken_image)),
                                ),
                              ),
                            ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(
                                liked
                                    ? Icons.thumb_up_alt
                                    : Icons.thumb_up_alt_outlined,
                                size: 16,
                                color:
                                    liked ? Colors.blue : Colors.grey.shade600,
                              ),
                              SizedBox(width: 4),
                              Text('$likes'),
                              SizedBox(width: 16),
                              Icon(Icons.comment_outlined,
                                  size: 16, color: Colors.grey.shade600),
                              SizedBox(width: 4),
                              Text('$comments'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}