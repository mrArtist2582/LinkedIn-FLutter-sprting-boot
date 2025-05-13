import 'package:flutter/material.dart';
import 'package:linked_in/model/post.dart';
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

  @override
  void initState() {
    super.initState();
    _postsFuture = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate delay
    return [
      Post(
        userName: 'Michael Chen',
        headline: 'Product Manager at InnovateTech',
        date: 'May 14, 2023',
        avatar: '',
        content: 'Just launched our new product after 6 months of hard work...',
        image:
            'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?auto=format&fit=crop&w=800&q=80',
        likes: 87,
        comments: 15,
        liked: false,
      ),
      Post(
        userName: 'Ava Patel',
        headline: 'UI/UX Designer at Creatives',
        date: 'May 10, 2023',
        avatar: '',
        content: 'Excited to share my latest design project! Feedback welcome.',
        image:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
        likes: 45,
        comments: 8,
        liked: false,
      ),
    ];
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _postsFuture = fetchPosts(); // refetch
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
                  backgroundImage: post.avatar != ''
                      ? NetworkImage(post.avatar)
                      : null,
                  radius: 24,
                  child: post.avatar == '' ? Text(post.userName[0]) : null,
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
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(post.image, fit: BoxFit.cover),
            ),
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
                TextButton.icon(
                  onPressed: () {
                    // open comment dialog
                  },
                  icon: const Icon(Icons.comment_outlined, color: Colors.grey),
                  label: Text(
                    '${post.comments} Comments',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Failed to load posts.'));
            }
            final posts = snapshot.data!;
            return LiquidPullToRefresh(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                itemBuilder: (context, index) =>
                    buildPostCard(posts[index], index, posts),
              ),
            );
          },
        );
      case 1:
        return const Center(
          child: Text('Create Post', style: TextStyle(fontSize: 20)),
        );
      case 2:
        return const JobsScreen();
      case 3:
        return const ProfileScreen();
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
                    decoration: InputDecoration(
                      hintText: 'Search jobs, people, posts...',
                      prefixIcon: const Icon(Icons.search),
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
      body: getCurrentScreen(),
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
