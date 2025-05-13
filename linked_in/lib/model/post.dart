class Post {
  final String userName;
  final String headline;
  final String date;
  final String avatar;
  final String content;
  final String image;
  int likes;
  final int comments;
  bool liked;

  Post({
    required this.userName,
    required this.headline,
    required this.date,
    required this.avatar,
    required this.content,
    required this.image,
    required this.likes,
    required this.comments,
    required this.liked,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userName: json['userName'],
      headline: json['headline'],
      date: json['date'],
      avatar: json['avatar'],
      content: json['content'],
      image: json['image'],
      likes: json['likes'],
      comments: json['comments'],
      liked: json['liked'],
    );
  }
}
