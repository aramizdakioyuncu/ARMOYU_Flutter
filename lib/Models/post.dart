class Post {
  int postId;
  String username;
  int userId;
  String avatar;
  String content;
  String mediaUrl;
  DateTime postDate;

  Post(this.postId, this.username, this.userId, this.avatar, this.content,
      this.mediaUrl, this.postDate);

  // JSON'dan Post nesnesi oluşturmak için yardımcı bir metot
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      json['postId'] as int,
      json['username'] as String,
      json['userId'] as int,
      json['avatar'] as String,
      json['content'] as String,
      json['mediaUrl'] as String,
      DateTime.parse(json['postDate'] as String),
    );
  }

  // Post sınıfını bir JSON nesnesine dönüştürmek için yardımcı bir metot
  Map<String, dynamic> toJson() => {
        'postId': postId,
        'username': username,
        'userId': userId,
        'avatar': avatar,
        'content': content,
        'mediaUrl': mediaUrl,
        'postDate': postDate.toIso8601String(),
      };
}
