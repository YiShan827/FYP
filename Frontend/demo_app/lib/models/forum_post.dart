class ForumPost {
  final int id;
  final int categoryId;
  final int userId;
  final String userName;
  final String title;
  final String content;
  final DateTime createdAt;
  final int replyCount;

  ForumPost({
    required this.id,
    required this.categoryId,
    required this.userId,
    required this.userName,
    required this.title,
    required this.content,
    required this.createdAt,
    this.replyCount = 0,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'],
      categoryId: json['categoryId'],
      userId: json['userId'],
      userName: json['userName'] ?? 'Anonymous',
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      replyCount: json['replyCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'categoryId': categoryId, 'title': title, 'content': content};
  }
}
