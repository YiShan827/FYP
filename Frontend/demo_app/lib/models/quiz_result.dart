class QuizResult {
  final int score;
  final bool isCorrect;
  final String correctAnswer;
  final String userAnswer;
  final String explanation;
  final String? feedback;

  QuizResult({
    required this.score,
    required this.isCorrect,
    required this.correctAnswer,
    required this.userAnswer,
    required this.explanation,
    this.feedback,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      score: json['score'],
      isCorrect: json['isCorrect'],
      correctAnswer: json['correctAnswer'],
      userAnswer: json['userAnswer'],
      explanation: json['explanation'],
      feedback: json['feedback'],
    );
  }
}
