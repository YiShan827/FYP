// dark_stats_screen.dart
import 'package:flutter/material.dart';
import '../models/user_stats.dart';
import '../services/quiz_api_service.dart';

class DarkStatsScreen extends StatefulWidget {
  @override
  _DarkStatsScreenState createState() => _DarkStatsScreenState();
}

class _DarkStatsScreenState extends State<DarkStatsScreen> {
  UserStats? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      setState(() => isLoading = true);

      final userStats = await QuizApiService.getUserStats();

      setState(() {
        stats = userStats;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Failed to load stats: $e');
    }
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
        title: const Text(
          'My Statistics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.greenAccent, size: 28),
            onPressed: loadStats,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body:
          isLoading
              ? _buildLoadingView()
              : stats == null
              ? _buildErrorView()
              : _buildStatsView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.greenAccent),
          SizedBox(height: 16),
          Text(
            'Loading your statistics...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Failed to load statistics',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: loadStats,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsView() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics, color: Colors.greenAccent, size: 50),
              const SizedBox(width: 10),
              const Text(
                'Your quiz performance statistics',
                style: TextStyle(fontSize: 16, color: Colors.greenAccent),
              ),
            ],
          ),
          const SizedBox(height: 30),

          Expanded(
            child: ListView(
              children: [
                _buildStatCard(
                  'Total Attempts',
                  '${stats!.totalAttempts}',
                  Icons.quiz,
                  Colors.blue,
                ),
                SizedBox(height: 12),
                _buildStatCard(
                  'Correct Answers',
                  '${stats!.correctAnswers}',
                  Icons.check_circle,
                  Colors.green,
                ),
                SizedBox(height: 12),
                _buildStatCard(
                  'Incorrect Answers',
                  '${stats!.incorrectAnswers}',
                  Icons.cancel,
                  Colors.red,
                ),
                SizedBox(height: 12),
                _buildStatCard(
                  'Accuracy',
                  stats!.accuracyPercentage,
                  Icons.trending_up,
                  _getAccuracyColor(stats!.accuracy),
                ),

                SizedBox(height: 30),

                // Accuracy Progress
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade700),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Accuracy Progress',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: stats!.accuracy / 100,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey.shade700,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getAccuracyColor(stats!.accuracy),
                              ),
                            ),
                          ),
                          Text(
                            '${stats!.accuracy.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getAccuracyColor(
                            stats!.accuracy,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _getAccuracyColor(
                              stats!.accuracy,
                            ).withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          _getEncouragementMessage(stats!.accuracy),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Achievements
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                _buildAchievementCard(
                  'First Quiz',
                  'Complete your first quiz',
                  Icons.play_circle_fill,
                  stats!.totalAttempts >= 1,
                ),
                SizedBox(height: 10),
                _buildAchievementCard(
                  'Quiz Master',
                  'Answer 10 questions correctly',
                  Icons.school,
                  stats!.correctAnswers >= 10,
                ),
                SizedBox(height: 10),
                _buildAchievementCard(
                  'Perfectionist',
                  'Achieve 90% accuracy',
                  Icons.star,
                  stats!.accuracy >= 90,
                ),
                SizedBox(height: 10),
                _buildAchievementCard(
                  'Persistent',
                  'Take 25 quiz attempts',
                  Icons.repeat,
                  stats!.totalAttempts >= 25,
                ),

                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[900],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.trending_up, color: Colors.grey.shade600, size: 20),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    String title,
    String description,
    IconData icon,
    bool isUnlocked,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isUnlocked ? Colors.green : Colors.grey.shade700,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[900],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isUnlocked
                      ? Colors.green.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: isUnlocked ? Colors.green : Colors.grey.shade600,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isUnlocked ? Colors.green : Colors.grey.shade400,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            isUnlocked ? Icons.check_circle : Icons.lock,
            color: isUnlocked ? Colors.green : Colors.grey.shade600,
            size: 20,
          ),
        ],
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getEncouragementMessage(double accuracy) {
    if (accuracy >= 90) {
      return "🎵 Excellent! You're a music quiz master!";
    } else if (accuracy >= 75) {
      return "🎼 Great job! Keep up the good work!";
    } else if (accuracy >= 50) {
      return "🎹 Good progress! Practice makes perfect!";
    } else if (stats!.totalAttempts < 5) {
      return "🎶 Just getting started! Take more quizzes to improve!";
    } else {
      return "🎵 Keep learning! Every attempt makes you better!";
    }
  }
}
