import 'package:demo_app/models/quiz.dart';
import 'package:flutter/material.dart';
import '../models/quiz_session.dart';
import '../models/quiz_result.dart';
import '../services/quiz_api_service.dart';

class DarkQuizScreen extends StatefulWidget {
  final int quizId;

  const DarkQuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  _DarkQuizScreenState createState() => _DarkQuizScreenState();
}

class _DarkQuizScreenState extends State<DarkQuizScreen>
    with TickerProviderStateMixin {
  QuizSession? quizSession;
  List<Quiz> quizQuestions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer; // Now stores "A", "B", "C", "D"
  bool isLoading = true;
  bool isSubmitting = false;
  bool showResult = false;
  QuizResult? result;
  double progress = 0.0;
  bool isAnswered = false;

  late AnimationController _resultController;
  late AnimationController _feedbackController;
  late Animation<double> _resultAnimation;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    startQuiz();
  }

  void _setupAnimations() {
    _resultController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _feedbackController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _resultAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );

    _feedbackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeInOut),
    );
  }

  Future<void> startQuiz() async {
    try {
      setState(() => isLoading = true);

      final session = await QuizApiService.startQuiz(widget.quizId);

      setState(() {
        quizSession = session;
        isLoading = false;
        selectedAnswer = null;
        showResult = false;
        result = null;
      });

      _resultController.reset();
      _feedbackController.reset();
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorAndGoBack('Failed to start quiz: $e');
    }
  }

  Future<void> submitAnswer() async {
    if (selectedAnswer == null) return;

    try {
      setState(() => isSubmitting = true);

      final quizResult = await QuizApiService.submitAnswer(
        widget.quizId,
        selectedAnswer!, // Now sends "A", "B", "C", "D"
      );

      setState(() {
        result = quizResult;
        showResult = true;
        isSubmitting = false;
        isAnswered = true;
        progress = 1.0;
      });

      _resultController.forward();

      Future.delayed(Duration(milliseconds: 400), () {
        if (mounted && showResult) {
          _feedbackController.forward();
        }
      });
    } catch (e) {
      setState(() => isSubmitting = false);
      _showError('Failed to submit answer: $e');
    }
  }

  void _tryAgain() {
    setState(() {
      selectedAnswer = null;
      showResult = false;
      result = null;
    });
    _resultController.reset();
    _feedbackController.reset();
    startQuiz();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorAndGoBack(String message) {
    _showError(message);
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  // Helper method to get option text from letter
  String _getOptionText(String letter) {
    if (quizSession == null) return '';

    switch (letter) {
      case 'A':
        return quizSession!.options['A'] ?? '';
      case 'B':
        return quizSession!.options['B'] ?? '';
      case 'C':
        return quizSession!.options['C'] ?? '';
      case 'D':
        return quizSession!.options['D'] ?? '';
      default:
        return '';
    }
  }

  // Build sorted option buttons
  List<Widget> _buildSortedOptionButtons() {
    var sortedEntries = quizSession!.options.entries.toList();
    sortedEntries.sort((a, b) => a.key.compareTo(b.key));

    return sortedEntries.map((entry) {
      final optionKey = entry.key; // "A", "B", "C", "D"
      final optionText = entry.value;
      final isSelected = selectedAnswer == optionKey;
      final isCorrect =
          showResult && result != null && optionKey == result!.correctAnswer;
      final isWrongSelection =
          showResult && result != null && isSelected && !result!.isCorrect;

      Color borderColor = Colors.grey;
      Color backgroundColor = Colors.grey[900]!;

      if (showResult && isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.2);
      } else if (showResult && isWrongSelection) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.2);
      } else if (isSelected) {
        borderColor = Colors.greenAccent;
        backgroundColor = Colors.grey[800]!;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          onTap:
              (isSubmitting || showResult)
                  ? null
                  : () {
                    setState(() {
                      selectedAnswer =
                          optionKey.toUpperCase(); // Send uppercase
                    });
                  },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: backgroundColor,
              boxShadow:
                  isSelected && !showResult
                      ? [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                      : null,
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.greenAccent : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.greenAccent : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      optionKey,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (showResult && isCorrect)
                  Icon(Icons.check, color: Colors.green, size: 24),
                if (showResult && isWrongSelection)
                  Icon(Icons.close, color: Colors.red, size: 24),
                if (isSelected && !showResult)
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 24),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildFeedbackCard() {
    if (!showResult || result == null || quizSession == null) {
      return SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _feedbackAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _feedbackAnimation.value,
          child: Opacity(
            opacity: _feedbackAnimation.value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: result!.isCorrect ? Colors.green : Colors.orange,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        result!.isCorrect
                            ? Icons.lightbulb
                            : Icons.info_outline,
                        color: result!.isCorrect ? Colors.green : Colors.orange,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        result!.isCorrect ? 'Well Done!' : 'Learn More',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (!result!.isCorrect) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                result!
                                    .correctAnswer, // Shows "A", "B", "C", "D"
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Correct answer: ${result!.correctAnswer} (${_getOptionText(result!.correctAnswer)})',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                  if (result!.feedback != null && result!.feedback!.isNotEmpty)
                    Text(
                      result!.feedback!,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    )
                  else if (result!.explanation.isNotEmpty)
                    Text(
                      result!.explanation,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    )
                  else
                    Text(
                      result!.isCorrect
                          ? 'Excellent! You got it right.'
                          : 'Keep practicing to improve your knowledge!',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Back to List'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _tryAgain,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Try Again'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _resultController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(
          height: 25,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: isAnswered ? 1.0 : 0.0),
              duration: Duration(milliseconds: 600),
              builder:
                  (context, value, _) => LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    minHeight: 8,
                  ),
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.greenAccent),
                    SizedBox(height: 16),
                    Text(
                      'Loading quiz...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          color: Colors.greenAccent,
                          size: 50,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Choose the correct answer',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.greenAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade700),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.help_outline,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  quizSession!.question,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Select your answer:',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          // Answer Options - sorted correctly
                          ..._buildSortedOptionButtons(),
                          const SizedBox(height: 30),
                          if (selectedAnswer != null && !showResult)
                            ElevatedButton(
                              onPressed: isSubmitting ? null : submitAnswer,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                                disabledBackgroundColor: Colors.grey[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                                  isSubmitting
                                      ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Submitting...',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      )
                                      : Text(
                                        'Submit Answer',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          if (showResult && result != null)
                            AnimatedBuilder(
                              animation: _resultAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _resultAnimation.value,
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      color: (result!.isCorrect
                                              ? Colors.green
                                              : Colors.red)
                                          .withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          result!.isCorrect
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          result!.isCorrect
                                              ? 'Correct!'
                                              : 'Incorrect!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          if (showResult && result != null)
                            _buildFeedbackCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
