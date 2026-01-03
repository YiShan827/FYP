class ForumReply {
  final int id;
  final int postId;
  final int userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  ForumReply({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  factory ForumReply.fromJson(Map<String, dynamic> json) {
    return ForumReply(
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      userName: json['userName'] ?? 'Anonymous',
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'postId': postId, 'content': content};
  }
}
