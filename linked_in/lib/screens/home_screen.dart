// home_screen.dart
import 'package:flutter/material.dart';
import 'package:linked_in/model/post.dart';
import 'package:linked_in/providers/home_screen_post_provider.dart';
import 'package:linked_in/widgets/create_post_card.dart';
import 'package:linked_in/widgets/open_comment_bottom_Sheet.dart';
import 'package:provider/provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import 'profile_screen.dart';
import 'jobs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Post>> _postsFuture;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchPosts();
  }

  Future<List<Post>> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await Provider.of<HomescreenPostProvider>(
        context,
        listen: false,
      ).fetchPosts();
      List<dynamic> postsData = Provider.of<HomescreenPostProvider>(
        context,
        listen: false,
      ).posts;

      if (postsData.isEmpty) {
        return [];
      }
      return postsData.map((post) {
        final user = post['user'] ?? {};
        return Post(
          id: post['id'] ?? '',
          userName: user['username'] ?? 'Unknown User',
          headline: user['email'] ?? '',
          date: post['createAt']?.toString().substring(0, 10) ?? '',
          avatar: user['avatar'] ?? '',
          content: post['content'] ?? '',
          image: post['url'] ?? '',
          likes: post['likes'] ?? 0,
          comments: post['comments'] ?? 0,
          liked: post['liked'] ?? false,
          userObject: user,
        );
      }).toList();
    } catch (error) {
      print("Error fetching posts: $error");
      _errorMessage = "Failed to load posts.";
      return [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchPosts(String keyword) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await Provider.of<HomescreenPostProvider>(
        context,
        listen: false,
      ).searchPosts(keyword);
      // After searching, rebuild the _buildHomeScreen with the filtered results
      setState(() {
        _postsFuture = Future.value(
          Provider.of<HomescreenPostProvider>(
            context,
            listen: false,
          ).searchResults.map((post) {
            final user = post['user'] ?? {};
            return Post(
              id: post['id'] ?? '',
              userName: user['username'] ?? 'Unknown User',
              headline: user['email'] ?? '',
              date: post['createAt']?.toString().substring(0, 10) ?? '',
              avatar: user['avatar'] ?? '',
              content: post['content'] ?? '',
              image: post['url'] ?? '',
              likes: post['likes'] ?? 0,
              comments: post['comments'] ?? 0,
              liked: post['liked'] ?? false,
              userObject: user,
            );
          }).toList(),
        );
      });
    } catch (error) {
      print("Error searching posts: $error");
      _errorMessage = "Failed to search posts.";
      setState(() {
        _postsFuture = Future.error(_errorMessage!);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _postsFuture = _fetchPosts();
    });
  }

  Widget buildPostCard(Post post, int index, List<Post> posts) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: post.avatar.isNotEmpty
                      ? NetworkImage(post.avatar)
                      : null,
                  radius: 24,
                  child: post.avatar.isEmpty
                      ? Text(
                          post.userName.isNotEmpty
                              ? post.userName[0].toUpperCase()
                              : '?',
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.headline,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        post.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(post.content),
            if (post.image.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Image failed to load');
                  },
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      post.liked = !post.liked;
                      post.likes += post.liked ? 1 : -1;
                    });
                  },
                  icon: Icon(
                    post.liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: post.liked
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  label: Text(
                    '${post.likes} Likes',
                    style: TextStyle(
                      color: post.liked
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final updatedCommentCount = await openCommentsBottomSheet(
                      context,
                      posts[index] as Map<String, dynamic>,
                    );
                    if (updatedCommentCount != null) {
                      setState(() {
                        posts[index].comments = updatedCommentCount;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.comment_outlined, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${post.comments} Comments',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeScreen() {
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load posts: ${snapshot.error}'));
        } else {
          final posts = snapshot.data ?? [];
          if (posts.isEmpty && !_isLoading) {
            return LiquidPullToRefresh(
              onRefresh: _refreshPosts,
              child: const Center(child: Text('No posts available.')),
            );
          }
          return LiquidPullToRefresh(
            onRefresh: _refreshPosts,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) =>
                  buildPostCard(posts[index], index, posts),
            ),
          );
        }
      },
    );
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return CreatePostCard(onPostCreated: _refreshPosts);
      case 2:
        return const JobsScreen();
      case 3:
        return ProfileScreen();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: const Text('LinkedIn'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (value) async {
                      final keyword = value.trim();
                      if (keyword.isNotEmpty) {
                        _searchPosts(keyword);
                      } else {
                        _refreshPosts(); // Reset to full list
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search posts...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _refreshPosts();
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: _getCurrentScreen(),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: Colors.white,
        waterDropColor: Theme.of(context).primaryColor,
        selectedIndex: _currentIndex,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        barItems: [
          BarItem(filledIcon: Icons.home, outlinedIcon: Icons.home_outlined),
          BarItem(
            filledIcon: Icons.add_box,
            outlinedIcon: Icons.add_box_outlined,
          ),
          BarItem(filledIcon: Icons.work, outlinedIcon: Icons.work_outline),
          BarItem(filledIcon: Icons.person, outlinedIcon: Icons.person_outline),
        ],
      ),
    );
  }
}

class CreatePostScreen {
  const CreatePostScreen();
}