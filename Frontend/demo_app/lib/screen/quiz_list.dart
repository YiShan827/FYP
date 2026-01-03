import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../services/quiz_api_service.dart';
import 'quiz_screen.dart';
import 'BiteSizedQuizScreen.dart';
import 'stats_screen.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  List<Quiz> quizzes = [];
  bool isLoading = true;
  String? selectedLevel;
  String? selectedTopic;
  List<String> levels = ['All', 'Beginner', 'Intermediate', 'Expert'];
  List<String> topics = ['All'];

  @override
  void initState() {
    super.initState();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    try {
      setState(() => isLoading = true);

      List<Quiz> fetchedQuizzes;

      if ((selectedLevel == null || selectedLevel == 'All') &&
          (selectedTopic == null || selectedTopic == 'All')) {
        fetchedQuizzes = await QuizApiService.getAllQuizzes();
      } else if (selectedLevel != null &&
          selectedLevel != 'All' &&
          (selectedTopic == null || selectedTopic == 'All')) {
        fetchedQuizzes = await QuizApiService.getQuizzesByLevelOnly(
          selectedLevel!,
        );
      } else if (selectedLevel != null &&
          selectedLevel != 'All' &&
          selectedTopic != null &&
          selectedTopic != 'All') {
        fetchedQuizzes = await QuizApiService.getQuizzesByTopicAndLevel(
          selectedTopic!,
          selectedLevel!,
        );
      } else {
        fetchedQuizzes = [];
      }

      setState(() {
        quizzes = fetchedQuizzes;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Failed to load quizzes: $e');
    }
  }

  void onLevelChanged(String? level) async {
    setState(() {
      selectedLevel = level;
      selectedTopic = 'All'; // reset topic
      topics = ['All']; // reset dropdown
    });

    if (level != null && level != 'All') {
      try {
        final fetchedTopics = await QuizApiService.getTopicsByLevel(level);
        setState(() {
          topics = ['All', ...fetchedTopics];
        });
      } catch (e) {
        _showError('Failed to load topics: $e');
      }
    }

    loadQuizzes();
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
        title: Text(
          'Music Quiz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.greenAccent, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DarkStatsScreen()),
              );
            },
            tooltip: 'View Stats',
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white, size: 24),
            onPressed: loadQuizzes,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadQuizzes,
        backgroundColor: Colors.grey[800],
        color: Colors.greenAccent,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildQuickStartSection(),
              _buildQuickLevelOptions(),
              SizedBox(height: 16),
              _buildDividerLabel('Individual Questions'),
              _buildLevelFilterSection(),

              // Quiz List Section
              isLoading
                  ? Container(
                    height: 300, // Give it a fixed height when loading
                    child: _buildLoading(),
                  )
                  : quizzes.isEmpty
                  ? Container(
                    height: 300, // Give it a fixed height when empty
                    child: _buildEmptyState(),
                  )
                  : ListView.builder(
                    shrinkWrap:
                        true, // Important: makes ListView take only needed space
                    physics:
                        NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 8.0,
                    ),
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = quizzes[index];
                      return _buildQuizCard(quiz, index);
                    },
                  ),

              // Bottom Button
              if (selectedLevel != null && selectedLevel != 'All')
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BiteSizedQuizScreen(
                                level: selectedLevel,
                                topic:
                                    selectedTopic != 'All'
                                        ? selectedTopic
                                        : null,
                                maxQuestions:
                                    null, // ✅ Show ALL filtered questions
                                isQuickSession: false,
                              ),
                        ),
                      ).then((_) => loadQuizzes());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Start Quiz',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

              // Add some bottom padding
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDividerLabel(String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade700, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade700, thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.greenAccent),
          SizedBox(height: 16),
          Text(
            'Loading quizzes...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartSection() {
    return Container(
      margin: EdgeInsets.all(14.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.greenAccent.withOpacity(0.8),
            Colors.green.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.flash_on, color: Colors.white, size: 28),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Quiz Session',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Bite-sized learning experience',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickFeature(Icons.timer, '2 mins'),
              _buildQuickFeature(Icons.quiz, '5 questions'),
              _buildQuickFeature(Icons.bolt, 'Instant feedback'),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BiteSizedQuizScreen(
                          maxQuestions: 5, // ✅ Always 5 questions
                          isQuickSession: true,
                        ),
                  ),
                ).then((_) => loadQuizzes());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Start Quick Quiz',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFeature(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLevelOptions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Quiz by Level:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildLevelQuickStart(
                  'Beginner',
                  Colors.green,
                  Icons.school,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildLevelQuickStart(
                  'Intermediate',
                  Colors.orange,
                  Icons.trending_up,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildLevelQuickStart(
                  'Expert',
                  Colors.red,
                  Icons.whatshot,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelQuickStart(String level, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BiteSizedQuizScreen(
                  level: level,
                  maxQuestions: 5, // ✅ Show ALL questions for this level
                  isQuickSession: false,
                ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 4),
            Text(
              level,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Quick',
              style: TextStyle(color: color.withOpacity(0.8), fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelFilterSection() {
    return Container(
      margin: EdgeInsets.all(14.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: Colors.greenAccent, size: 20),
              SizedBox(width: 10),
              Text(
                'Filter:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Level Dropdown
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade600),
            ),
            child: DropdownButton<String>(
              value: selectedLevel ?? 'All',
              isExpanded: true,
              dropdownColor: Colors.grey[800],
              style: TextStyle(color: Colors.white, fontSize: 14),
              underline: SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade400,
              ),
              items:
                  levels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
              onChanged: (value) async {
                setState(() {
                  selectedLevel = value;
                  selectedTopic = 'All'; // reset topic dropdown
                  topics = ['All']; // reset topics list
                });

                if (value != null && value != 'All') {
                  try {
                    final fetchedTopics = await QuizApiService.getTopicsByLevel(
                      value,
                    );
                    setState(() {
                      topics = [
                        'All',
                        ...fetchedTopics,
                      ]; // populate topic dropdown
                    });
                  } catch (e) {
                    _showError('Failed to load topics: $e');
                  }
                }

                loadQuizzes();
              },
            ),
          ),
          SizedBox(height: 12),
          // Topic Dropdown
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade600),
            ),
            child: DropdownButton<String>(
              value: selectedTopic ?? 'All',
              isExpanded: true,
              dropdownColor: Colors.grey[800],
              style: TextStyle(color: Colors.white, fontSize: 14),
              underline: SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade400,
              ),
              items:
                  topics.map((topic) {
                    return DropdownMenuItem(
                      value: topic,
                      child: Text(topic, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() => selectedTopic = value);
                loadQuizzes(); // reload quizzes based on level + topic
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.quiz, size: 64, color: Colors.grey.shade600),
          ),
          SizedBox(height: 24),
          Text(
            'No quizzes available',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          if (selectedLevel != null && selectedLevel != 'All')
            Text(
              'for $selectedLevel level',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: loadQuizzes,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, size: 18),
                SizedBox(width: 8),
                Text('Retry'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(Quiz quiz, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DarkQuizScreen(quizId: quiz.id),
              ),
            ).then((_) => loadQuizzes());
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade700, width: 1),
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[900],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _getLevelColor(quiz.level).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getLevelColor(quiz.level).withOpacity(0.5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: _getLevelColor(quiz.level),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${index + 1}',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            quiz.level,
                            style: TextStyle(
                              color: _getLevelColor(quiz.level),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade500,
                      size: 16,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  quiz.question,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoTag(quiz.topic, Icons.topic, Colors.blue),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.green, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Take Quiz',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }

  Widget _buildInfoTag(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'expert':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
