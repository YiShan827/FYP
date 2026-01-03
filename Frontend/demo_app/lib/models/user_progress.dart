class UserProgress {
  final String username;
  final int completedQuizzes;
  final String level;

  UserProgress({
    required this.username,
    required this.completedQuizzes,
    required this.level,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      username: json['username'] ?? '',
      completedQuizzes: json['completedQuizzes'] ?? 0,
      level: json['level'] ?? 'N/A',
    );
  }
}
