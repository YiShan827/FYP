import 'package:demo_app/screen/BiteSizedQuizScreen.dart';
import 'package:flutter/material.dart';

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

class QuizResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final List<QuizAnswer> answers;
  final bool isQuickSession;
  final String? level;
  final String? topic;
  final Duration timeSpent;

  const QuizResultScreen({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.answers,
    this.isQuickSession = false,
    this.level,
    this.topic,
    required this.timeSpent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage =
        totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;
    final String grade = _getGrade(percentage);
    final Color gradeColor = _getGradeColor(percentage);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradeColor.withOpacity(0.8),
                    gradeColor.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getGradeIcon(percentage),
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isQuickSession ? 'Quick Quiz Results' : 'Quiz Results',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Main Score Card
              _buildScoreCard(percentage, grade, gradeColor),
              const SizedBox(height: 24),

              // Stats Row
              _buildStatsRow(),
              const SizedBox(height: 24),

              // Progress Bar
              _buildProgressBar(percentage, gradeColor),
              const SizedBox(height: 24),

              // Session Info
              _buildSessionInfo(),
              const SizedBox(height: 24),

              // Answer Breakdown
              if (answers.isNotEmpty) _buildAnswerBreakdown(),
              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(double percentage, String grade, Color gradeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E1E1E).withOpacity(0.8),
            const Color(0xFF2D2D2D).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gradeColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: gradeColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradeColor.withOpacity(0.2),
                  gradeColor.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(_getGradeIcon(percentage), size: 64, color: gradeColor),
          ),
          const SizedBox(height: 20),
          Text(
            grade,
            style: TextStyle(
              color: gradeColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$correctAnswers out of $totalQuestions correct',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total',
            totalQuestions.toString(),
            Icons.quiz_outlined,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Correct',
            correctAnswers.toString(),
            Icons.check_circle_outline,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Wrong',
            (totalQuestions - correctAnswers).toString(),
            Icons.cancel_outlined,
            Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Time',
            _formatDuration(timeSpent),
            Icons.timer_outlined,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D2D2D).withOpacity(0.8),
            const Color(0xFF3D3D3D).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double percentage, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D2D2D).withOpacity(0.8),
            const Color(0xFF3D3D3D).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: color, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Performance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                _getPerformanceText(percentage),
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D2D2D).withOpacity(0.8),
            const Color(0xFF3D3D3D).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Session Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Quiz Type',
            isQuickSession ? 'Quick Session' : 'Full Quiz',
          ),
          if (level != null) _buildInfoRow('Level', level!),
          if (topic != null) _buildInfoRow('Topic', topic!),
          _buildInfoRow('Duration', _formatDuration(timeSpent)),
          _buildInfoRow(
            'Questions',
            '$totalQuestions ${totalQuestions == 1 ? 'question' : 'questions'}',
          ),
          _buildInfoRow(
            'Accuracy',
            '${((correctAnswers / totalQuestions) * 100).toStringAsFixed(1)}%',
          ),
          if (totalQuestions > 0)
            _buildInfoRow(
              'Avg. Time/Question',
              _formatDuration(
                Duration(
                  milliseconds: timeSpent.inMilliseconds ~/ totalQuestions,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D2D2D).withOpacity(0.8),
            const Color(0xFF3D3D3D).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.list_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Answer Breakdown',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${answers.length} ${answers.length == 1 ? 'answer' : 'answers'}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...answers.asMap().entries.map((entry) {
            int index = entry.key;
            QuizAnswer answer = entry.value;
            return _buildAnswerCard(index + 1, answer);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(int questionNumber, QuizAnswer answer) {
    bool isCorrect = answer.isCorrect;
    Color cardColor = isCorrect ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cardColor.withOpacity(0.1), cardColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cardColor.withOpacity(0.8),
                      cardColor.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    questionNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  answer.question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: cardColor,
                  size: 16,
                ),
              ),
            ],
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your answer: ${answer.userAnswer}',
                        style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Correct answer: ${answer.correctAnswer}',
                        style: TextStyle(
                          color: Colors.green.shade300,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (isQuickSession) ...[
          // Quick session buttons
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BiteSizedQuizScreen(
                            maxQuestions: 5,
                            isQuickSession: true,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Try Another Quick Quiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ] else ...[
          // Full quiz buttons
          if (level != null)
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BiteSizedQuizScreen(
                              level: level,
                              topic: topic,
                              maxQuestions: null,
                              isQuickSession: false,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.replay, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Retake This Quiz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withOpacity(0.3)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text(
                  'Back to Home',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods
  String _getGrade(double percentage) {
    if (percentage >= 90) return 'Excellent!';
    if (percentage >= 80) return 'Great!';
    if (percentage >= 70) return 'Good';
    if (percentage >= 60) return 'Fair';
    return 'Keep Trying!';
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getGradeIcon(double percentage) {
    if (percentage >= 90) return Icons.emoji_events;
    if (percentage >= 80) return Icons.thumb_up;
    if (percentage >= 60) return Icons.trending_up;
    return Icons.refresh;
  }

  String _getPerformanceText(double percentage) {
    if (percentage >= 90) return 'Outstanding';
    if (percentage >= 80) return 'Excellent';
    if (percentage >= 70) return 'Good';
    if (percentage >= 60) return 'Average';
    return 'Needs Practice';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
