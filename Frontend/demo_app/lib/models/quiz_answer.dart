// QuizAnswer model for detailed results
class QuizAnswer {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;

  QuizAnswer({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });
}
