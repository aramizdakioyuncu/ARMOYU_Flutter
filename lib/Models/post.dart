class Post {
  int postId;
  String username;
  int userId;
  String avatar;
  String content;
  String mediaUrl;
  DateTime postDate;

  Post({
    required this.postId,
    required this.username,
    required this.userId,
    required this.avatar,
    required this.content,
    required this.mediaUrl,
    required this.postDate,
  });
}
