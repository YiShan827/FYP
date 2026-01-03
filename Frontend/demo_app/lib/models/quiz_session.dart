class QuizSession {
  final int sessionId;
  final int quizId;
  final String question;
  final Map<String, String> options;
  final String topic;
  final String level;
  final String? feedback;

  QuizSession({
    required this.sessionId,
    required this.quizId,
    required this.question,
    required this.options,
    required this.topic,
    required this.level,
    this.feedback,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      sessionId: json['sessionId'],
      quizId: json['quizId'],
      question: json['question'],
      options: Map<String, String>.from(json['options']),
      topic: json['topic'],
      level: json['level'],
      feedback: json['feedback'],
    );
  }
}
