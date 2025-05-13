import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final Function(String) onComment;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post['author']['profilePicture'] ?? ''),
              onBackgroundImageError: (_, __) {},
              child: post['author']['profilePicture'] == null
                  ? Text(post['author']['name'][0].toUpperCase())
                  : null,
            ),
            title: Text(
              post['author']['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              timeago.format(DateTime.parse(post['createdAt'])),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (post['content'] != null && post['content'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(post['content']),
            ),
          if (post['image'] != null)
            Image.network(
              post['image'],
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onLike,
                  icon: Icon(
                    post['isLiked'] == true
                        ? Icons.thumb_up
                        : Icons.thumb_up_outlined,
                    color: post['isLiked'] == true
                        ? Theme.of(context).primaryColor
                        : null,
                  ),
                  label: Text(
                    '${post['likes']}',
                    style: TextStyle(
                      color: post['isLiked'] == true
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    _showCommentDialog(context);
                  },
                  icon: const Icon(Icons.comment_outlined),
                  label: Text('${post['comments'].length}'),
                ),
              ),
             
            ],
          ),
          if (post['comments'].isNotEmpty) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...post['comments'].map<Widget>((comment) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                                comment['author']['profilePicture'] ?? ''),
                            onBackgroundImageError: (_, __) {},
                            child: comment['author']['profilePicture'] == null
                                ? Text(comment['author']['name'][0].toUpperCase())
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['author']['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(comment['content']),
                                Text(
                                  timeago.format(
                                      DateTime.parse(comment['createdAt'])),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Write a comment...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onComment(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Comment'),
          ),
        ],
      ),
    );
  }
} 