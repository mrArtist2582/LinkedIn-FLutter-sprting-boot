class Post {
  final String userName;
  final String headline;
  final String date;
  final String avatar;
  final String content;
  final String image;
  int likes;
  int comments;
  bool liked;
  final dynamic id; // Assuming your posts have an ID
  final dynamic userObject; // To hold the original user data if needed

  Post({
    required this.userName,
    required this.headline,
    required this.date,
    required this.avatar,
    required this.content,
    required this.image,
    this.likes = 0,
    this.comments = 0,
    this.liked = false,
    this.id,
    this.userObject,
  });
}