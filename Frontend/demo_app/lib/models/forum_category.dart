class ForumCategory {
  final int id;
  final String name;
  final String description;
  final int postCount;

  ForumCategory({
    required this.id,
    required this.name,
    required this.description,
    this.postCount = 0,
  });

  factory ForumCategory.fromJson(Map<String, dynamic> json) {
    return ForumCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      postCount: json['postCount'] ?? 0,
    );
  }
}
