class Quiz {
  final int id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;
  final String topic;
  final String level;
  final String? feedback;
  final DateTime? createdAt;

  Quiz({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.topic,
    required this.level,
    this.createdAt,
    this.feedback,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      question: json['question'],
      optionA: json['optionA'],
      optionB: json['optionB'],
      optionC: json['optionC'],
      optionD: json['optionD'],
      correctAnswer: json['correctAnswer'],
      topic: json['topic'],
      level: json['level'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'optionD': optionD,
      'correctAnswer': correctAnswer,
      'topic': topic,
      'level': level,
      'createdAt': createdAt?.toIso8601String(),
      'feedback': feedback,
    };
  }

  List<String> get options => [optionA, optionB, optionC, optionD];

  Map<String, String> get optionsMap => {
    'A': optionA,
    'B': optionB,
    'C': optionC,
    'D': optionD,
  };
}
