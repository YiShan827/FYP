class UserStats {
  final int totalAttempts;
  final int correctAnswers;
  final double accuracy;

  UserStats({
    required this.totalAttempts,
    required this.correctAnswers,
    required this.accuracy,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalAttempts: json['totalAttempts'],
      correctAnswers: json['correctAnswers'],
      accuracy: (json['accuracy'] as num).toDouble(),
    );
  }

  int get incorrectAnswers => totalAttempts - correctAnswers;
  String get accuracyPercentage => '${accuracy.toStringAsFixed(1)}%';
}
