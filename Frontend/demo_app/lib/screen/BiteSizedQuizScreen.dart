import 'package:flutter/material.dart';
import 'dart:math';
import '../models/quiz.dart';
// import '../models/quiz_result.dart';
import '../services/quiz_api_service.dart';

class BiteSizedQuizScreen extends StatefulWidget {
  final String? level;
  final String? topic;
  final int? maxQuestions;
  final bool isQuickSession;

  const BiteSizedQuizScreen({
    Key? key,
    this.level,
    this.topic,
    this.maxQuestions,
    this.isQuickSession = false,
  }) : super(key: key);

  @override
  _BiteSizedQuizScreenState createState() => _BiteSizedQuizScreenState();
}

class _BiteSizedQuizScreenState extends State<BiteSizedQuizScreen>
    with TickerProviderStateMixin {
  List<Quiz> quizQuestions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer; // Now stores "A", "B", "C", "D"
  bool showResult = false;
  bool isLoading = true;
  int correctAnswers = 0;
  int totalQuestions = 5;
  bool isSubmitting = false;
  bool isCorrectAnswer = false;

  late AnimationController _progressController;
  late AnimationController _resultController;
  late AnimationController _feedbackController;
  late Animation<double> _progressAnimation;
  late Animation<double> _resultAnimation;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    loadBiteSizedQuiz();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _resultController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _feedbackController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _resultAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );

    _feedbackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeInOut),
    );
  }

  Future<void> loadBiteSizedQuiz() async {
    try {
      setState(() => isLoading = true);

      List<Quiz> allQuizzes;

      if (widget.level != null &&
          widget.level != 'All' &&
          widget.topic != null &&
          widget.topic != 'All') {
        allQuizzes = await QuizApiService.getQuizzesByTopicAndLevel(
          widget.topic!,
          widget.level!,
        );
      } else if (widget.level != null && widget.level != 'All') {
        allQuizzes = await QuizApiService.getQuizzesByLevelOnly(widget.level!);
      } else {
        allQuizzes = await QuizApiService.getAllQuizzes();
      }

      allQuizzes.shuffle(Random());

      int questionsToTake;
      if (widget.maxQuestions != null && widget.maxQuestions! > 0) {
        questionsToTake = widget.maxQuestions!;
      } else {
        questionsToTake = allQuizzes.length;
      }

      quizQuestions = allQuizzes.take(questionsToTake).toList();
      totalQuestions = quizQuestions.length;

      setState(() => isLoading = false);
      _progressController.forward();
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorAndGoBack('Failed to load quiz: $e');
    }
  }

  Future<void> submitAnswer() async {
    if (selectedAnswer == null) return;

    setState(() => isSubmitting = true);

    try {
      final result = await QuizApiService.submitAnswer(
        quizQuestions[currentQuestionIndex].id,
        selectedAnswer!,
      );

      isCorrectAnswer = result.isCorrect;
      if (result.isCorrect) {
        correctAnswers++;
      }

      setState(() {
        showResult = true;
        isSubmitting = false;
      });

      _resultController.forward();

      Future.delayed(Duration(milliseconds: 200), () {
        if (mounted) {
          _feedbackController.forward();
        }
      });
    } catch (e) {
      setState(() => isSubmitting = false);
      _showError('Failed to submit: $e');
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showResult = false;
        isCorrectAnswer = false;
      });

      _resultController.reset();
      _feedbackController.reset();
      _progressController.animateTo(
        (currentQuestionIndex + 1) / quizQuestions.length,
      );
    } else {
      _showFinalResults();
    }
  }

  void _showFinalResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildFinalResultsDialog(),
    );
  }

  Widget _buildFinalResultsDialog() {
    double accuracy = (correctAnswers / totalQuestions) * 100;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate adaptive sizes for landscape
    final iconSize = isLandscape ? 60.0 : 80.0;
    final titleFontSize = isLandscape ? 20.0 : 24.0;
    final subtitleFontSize = isLandscape ? 14.0 : 16.0;
    final circleSize = isLandscape ? 80.0 : 100.0;
    final percentageFontSize = isLandscape ? 20.0 : 24.0;
    final dialogPadding = isLandscape ? 16.0 : 24.0;
    final verticalSpacing = isLandscape ? 8.0 : 16.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.8, // Limit dialog height to 80% of screen
          maxWidth: isLandscape ? 600 : 400,
        ),
        child: Container(
          padding: EdgeInsets.all(dialogPadding),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.greenAccent, width: 2),
          ),
          child: SingleChildScrollView(
            // Make dialog scrollable
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getAccuracyColor(accuracy).withOpacity(0.2),
                  ),
                  child: Icon(
                    accuracy >= 80 ? Icons.celebration : Icons.thumb_up,
                    color: _getAccuracyColor(accuracy),
                    size: iconSize * 0.5,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  'Quiz Complete!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: verticalSpacing * 0.5),
                Text(
                  'You got $correctAnswers out of $totalQuestions questions right!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: subtitleFontSize,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getAccuracyColor(accuracy),
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${accuracy.toInt()}%',
                      style: TextStyle(
                        color: _getAccuracyColor(accuracy),
                        fontSize: percentageFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing * 1.5),
                // Responsive button layout for landscape
                isLandscape
                    ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Text('Done', style: TextStyle(fontSize: 14)),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _restartQuiz();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Text(
                              'Try Again',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _restartQuiz();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text('Try Again'),
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text('Done'),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswer = null;
      showResult = false;
      correctAnswers = 0;
      isCorrectAnswer = false;
    });
    _progressController.reset();
    _resultController.reset();
    _feedbackController.reset();
    loadBiteSizedQuiz();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showErrorAndGoBack(String message) {
    _showError(message);
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  // Helper method to get option text from letter
  String _getOptionText(String letter) {
    final currentQuiz = quizQuestions[currentQuestionIndex];
    switch (letter) {
      case 'A':
        return currentQuiz.optionA;
      case 'B':
        return currentQuiz.optionB;
      case 'C':
        return currentQuiz.optionC;
      case 'D':
        return currentQuiz.optionD;
      default:
        return '';
    }
  }

  Widget _buildFeedbackCard() {
    final currentQuiz = quizQuestions[currentQuestionIndex];
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return AnimatedBuilder(
      animation: _feedbackAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _feedbackAnimation.value,
          child: Opacity(
            opacity: _feedbackAnimation.value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(isLandscape ? 12 : 20),
              margin: EdgeInsets.only(top: isLandscape ? 8 : 20),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isCorrectAnswer ? Colors.green : Colors.orange,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrectAnswer ? Icons.lightbulb : Icons.info_outline,
                        color: isCorrectAnswer ? Colors.green : Colors.orange,
                        size: isLandscape ? 20 : 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        isCorrectAnswer ? 'Well Done!' : 'Learn More',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isLandscape ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isLandscape ? 8 : 12),
                  if (!isCorrectAnswer) ...[
                    Container(
                      padding: EdgeInsets.all(isLandscape ? 8 : 12),
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
                            width: isLandscape ? 20 : 24,
                            height: isLandscape ? 20 : 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                currentQuiz.correctAnswer,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isLandscape ? 10 : 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Correct answer: ${currentQuiz.correctAnswer} (${_getOptionText(currentQuiz.correctAnswer)})',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: isLandscape ? 12 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isLandscape ? 8 : 12),
                  ],
                  if (currentQuiz.feedback != null &&
                      currentQuiz.feedback!.isNotEmpty) ...[
                    Text(
                      'Explanation:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isLandscape ? 12 : 14,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      currentQuiz.feedback!,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: isLandscape ? 12 : 14,
                        height: 1.4,
                      ),
                    ),
                  ] else ...[
                    Text(
                      isCorrectAnswer
                          ? 'Great job! You got it right.'
                          : 'Don\'t worry, keep practicing!',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: isLandscape ? 12 : 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                  SizedBox(height: isLandscape ? 8 : 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => _nextQuestion(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: isLandscape ? 16 : 20,
                            vertical: isLandscape ? 6 : 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentQuestionIndex < quizQuestions.length - 1
                                  ? 'Next'
                                  : 'Finish',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: isLandscape ? 12 : 14,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              currentQuestionIndex < quizQuestions.length - 1
                                  ? Icons.arrow_forward_ios
                                  : Icons.check,
                              size: isLandscape ? 12 : 16,
                            ),
                          ],
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
    _progressController.dispose();
    _resultController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.greenAccent),
              SizedBox(height: 16),
              Text(
                'Preparing your bite-sized quiz...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (quizQuestions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No questions available',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    final currentQuiz = quizQuestions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / quizQuestions.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isLandscape ? 12 : 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Container(
                          height: 8,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _progressAnimation.value * progress,
                              backgroundColor: Colors.grey.shade700,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.greenAccent,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    '${currentQuestionIndex + 1}/$totalQuestions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isLandscape ? 16 : 40),
              Expanded(
                child: SingleChildScrollView(
                  // Added SingleChildScrollView to prevent overflow
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(currentQuestionIndex),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isLandscape ? 16 : 24),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade700),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.music_note,
                                  color: Colors.greenAccent,
                                  size: isLandscape ? 24 : 32,
                                ),
                                SizedBox(height: isLandscape ? 8 : 16),
                                Text(
                                  currentQuiz.question,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isLandscape ? 16 : 20,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isLandscape ? 16 : 32),
                          // Options layout adapted for landscape
                          isLandscape
                              ? _buildLandscapeOptions(currentQuiz)
                              : _buildPortraitOptions(currentQuiz),

                          if (selectedAnswer != null &&
                              !showResult &&
                              !isSubmitting)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                top: isLandscape ? 12 : 20,
                              ),
                              child: ElevatedButton(
                                onPressed: submitAnswer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    vertical: isLandscape ? 12 : 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Submit Answer',
                                  style: TextStyle(
                                    fontSize: isLandscape ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (showResult)
                            AnimatedBuilder(
                              animation: _resultAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _resultAnimation.value,
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      isLandscape ? 12 : 20,
                                    ),
                                    margin: EdgeInsets.only(
                                      top: isLandscape ? 12 : 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (isCorrectAnswer
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
                                          isCorrectAnswer
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: Colors.white,
                                          size: isLandscape ? 24 : 32,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          isCorrectAnswer
                                              ? 'Correct!'
                                              : 'Incorrect!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isLandscape ? 16 : 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          if (showResult) _buildFeedbackCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeOptions(Quiz currentQuiz) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildOptionButton('A', currentQuiz.optionA)),
            SizedBox(width: 8),
            Expanded(child: _buildOptionButton('B', currentQuiz.optionB)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildOptionButton('C', currentQuiz.optionC)),
            SizedBox(width: 8),
            Expanded(child: _buildOptionButton('D', currentQuiz.optionD)),
          ],
        ),
      ],
    );
  }

  Widget _buildPortraitOptions(Quiz currentQuiz) {
    return Column(
      children: [
        _buildOptionButton('A', currentQuiz.optionA),
        SizedBox(height: 12),
        _buildOptionButton('B', currentQuiz.optionB),
        SizedBox(height: 12),
        _buildOptionButton('C', currentQuiz.optionC),
        SizedBox(height: 12),
        _buildOptionButton('D', currentQuiz.optionD),
      ],
    );
  }

  Widget _buildOptionButton(String optionKey, String optionText) {
    final isSelected = selectedAnswer == optionKey;
    final isCorrect =
        optionKey == quizQuestions[currentQuestionIndex].correctAnswer;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    Color borderColor = Colors.grey;
    Color backgroundColor = Colors.grey[900]!;

    if (showResult && isCorrect) {
      borderColor = Colors.green;
      backgroundColor = Colors.green.withOpacity(0.2);
    } else if (showResult && isSelected && !isCorrect) {
      borderColor = Colors.red;
      backgroundColor = Colors.red.withOpacity(0.2);
    } else if (isSelected) {
      borderColor = Colors.greenAccent;
      backgroundColor = Colors.grey[800]!;
    }

    return GestureDetector(
      onTap:
          (showResult || isSubmitting)
              ? null
              : () {
                Future.delayed(Duration(milliseconds: 300), () {
                  setState(() => selectedAnswer = optionKey);
                });
              },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(isLandscape ? 12 : 20),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(15),
          color: backgroundColor,
        ),
        child: Row(
          children: [
            Container(
              width: isLandscape ? 24 : 32,
              height: isLandscape ? 24 : 32,
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
                    fontSize: isLandscape ? 12 : 16,
                  ),
                ),
              ),
            ),
            SizedBox(width: isLandscape ? 8 : 16),
            Expanded(
              child: Text(
                optionText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isLandscape ? 12 : 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: isLandscape ? 2 : null,
                overflow: isLandscape ? TextOverflow.ellipsis : null,
              ),
            ),
            if (showResult && isCorrect)
              Icon(
                Icons.check,
                color: Colors.green,
                size: isLandscape ? 20 : 24,
              ),
            if (showResult && isSelected && !isCorrect)
              Icon(Icons.close, color: Colors.red, size: isLandscape ? 20 : 24),
          ],
        ),
      ),
    );
  }
}
