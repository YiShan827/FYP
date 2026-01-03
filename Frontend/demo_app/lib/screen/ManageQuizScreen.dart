import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ManageQuizzesScreen extends StatefulWidget {
  const ManageQuizzesScreen({super.key});

  @override
  State<ManageQuizzesScreen> createState() => _ManageQuizzesScreenState();
}

class _ManageQuizzesScreenState extends State<ManageQuizzesScreen> {
  List<dynamic> quizzes = [];
  List<dynamic> filteredQuizzes = [];
  Map<String, Map<String, List<dynamic>>> groupedQuizzes = {};
  bool isLoading = true;

  String? selectedLevel;
  String? selectedTopic;
  List<String> availableLevels = [];
  List<String> availableTopics = [];

  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/quizzes'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        quizzes = json.decode(response.body);
        groupQuizzes();
        setupDropdownData();
        filteredQuizzes = List.from(quizzes);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Failed to load quizzes: ${response.body}");
    }
  }

  void groupQuizzes() {
    groupedQuizzes.clear();

    for (var quiz in quizzes) {
      String level = quiz['level']?.toString().toUpperCase() ?? 'UNKNOWN';
      String topic =
          quiz['topic']?.toString() ??
          'General'; // Assuming you have a topic field

      // If topic field doesn't exist, you can derive it from question or use a default
      // topic = quiz['category'] ?? 'General'; // Alternative field name

      if (!groupedQuizzes.containsKey(level)) {
        groupedQuizzes[level] = {};
      }

      if (!groupedQuizzes[level]!.containsKey(topic)) {
        groupedQuizzes[level]![topic] = [];
      }

      groupedQuizzes[level]![topic]!.add(quiz);
    }
  }

  void setupDropdownData() {
    Set<String> levels = {};
    Set<String> topics = {};

    for (var quiz in quizzes) {
      String level = quiz['level']?.toString().toUpperCase() ?? 'UNKNOWN';
      String topic = quiz['topic']?.toString().trim() ?? 'General';
      if (topic.isEmpty) {
        topic = 'General';
      }

      levels.add(level);
      topics.add(topic);
    }

    availableLevels =
        ['All Levels'] + levels.toList()
          ..sort();
    availableTopics =
        ['All Topics'] + topics.toList()
          ..sort();

    // Safety check: Reset selected values if they no longer exist
    if (selectedLevel != null && !availableLevels.contains(selectedLevel)) {
      selectedLevel = null;
    }

    if (selectedTopic != null && !availableTopics.contains(selectedTopic)) {
      selectedTopic = null;
    }
  }

  List<String> getAvailableTopicsForLevel() {
    if (selectedLevel == null || selectedLevel == 'All Levels') {
      return availableTopics; // Show all topics if no level selected
    }

    // Get topics only for the selected level
    Set<String> topicsForLevel = {};

    for (var quiz in quizzes) {
      String level = quiz['level']?.toString().toUpperCase() ?? 'UNKNOWN';
      String topic = quiz['topic']?.toString().trim() ?? 'General';
      if (topic.isEmpty) topic = 'General';

      if (level == selectedLevel) {
        topicsForLevel.add(topic);
      }
    }

    return ['All Topics'] + topicsForLevel.toList()
      ..sort();
  }

  void onLevelChanged(String? newValue) {
    setState(() {
      selectedLevel = newValue;

      // Reset topic selection when level changes
      List<String> availableTopicsForNewLevel = getAvailableTopicsForLevel();
      if (selectedTopic != null &&
          !availableTopicsForNewLevel.contains(selectedTopic)) {
        selectedTopic =
            null; // Reset topic if it's not available for this level
      }

      filterQuizzes();
    });
  }

  void onTopicChanged(String? newValue) {
    setState(() {
      selectedTopic = newValue;
      filterQuizzes();
    });
  }

  // Also update your filterQuizzes method to handle trimming consistently:
  void filterQuizzes() {
    setState(() {
      filteredQuizzes =
          quizzes.where((quiz) {
            String level = quiz['level']?.toString().toUpperCase() ?? 'UNKNOWN';
            String topic = quiz['topic']?.toString().trim() ?? 'General';
            if (topic.isEmpty) topic = 'General';

            bool levelMatch =
                selectedLevel == null ||
                selectedLevel == 'All Levels' ||
                level == selectedLevel;

            bool topicMatch =
                selectedTopic == null ||
                selectedTopic == 'All Topics' ||
                topic == selectedTopic;

            return levelMatch && topicMatch;
          }).toList();
    });
  }

  Future<void> deleteQuiz(int quizId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8080/api/quizzes/$quizId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Quiz deleted successfully"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Reset filters before fetching new data
      setState(() {
        selectedLevel = null;
        selectedTopic = null;
      });

      // Fetch updated data
      await fetchQuizzes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete quiz: ${response.body}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void showDeleteConfirmationDialog(int quizId, String question) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Confirm Deletion",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Are you sure you want to delete this quiz?",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteQuiz(quizId);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildFilterSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E1E1E).withOpacity(0.8),
            const Color(0xFF2D2D2D).withOpacity(0.6),
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
              const Icon(
                Icons.filter_list_rounded,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Filter Quizzes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (selectedLevel != null || selectedTopic != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedLevel = null;
                      selectedTopic = null;
                      filteredQuizzes = List.from(quizzes);
                    });
                  },
                  child: const Text(
                    'Clear Filters',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Level',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedLevel,
                          hint: const Text(
                            'Select Level',
                            style: TextStyle(color: Colors.white54),
                          ),
                          dropdownColor: const Color(0xFF2D2D2D),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white70,
                          ),
                          isExpanded: true,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          items:
                              availableLevels.map((String level) {
                                return DropdownMenuItem<String>(
                                  value: level,
                                  child: Text(
                                    level,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                          onChanged: onLevelChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Topic',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTopic,
                          hint: const Text(
                            'Select Topic',
                            style: TextStyle(color: Colors.white54),
                          ),
                          dropdownColor: const Color(0xFF2D2D2D),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white70,
                          ),
                          isExpanded: true,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          items:
                              getAvailableTopicsForLevel().map((String topic) {
                                return DropdownMenuItem<String>(
                                  value: topic,
                                  child: Text(
                                    topic,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                          onChanged: onTopicChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Showing ${filteredQuizzes.length} of ${quizzes.length} quizzes',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuizCard(dynamic quiz) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D2D2D).withOpacity(0.8),
            const Color(0xFF3D3D3D).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          quiz['question'] ?? 'No Question',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Level: ${quiz['level']?.toString().toUpperCase() ?? 'N/A'}",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Topic: ${quiz['topic']?.toString() ?? 'General'}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "ID: ${quiz['id']}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed:
                () => showDeleteConfirmationDialog(
                  quiz['id'],
                  quiz['question'] ?? 'No Question',
                ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.quiz_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Manage Quizzes",
              style: TextStyle(
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
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
                : quizzes.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 64,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No quizzes available",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Create your first quiz to get started",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
                : Column(
                  children: [
                    buildFilterSection(),
                    Expanded(
                      child:
                          filteredQuizzes.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No quizzes match your filters",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Try adjusting your filter criteria",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ListView.builder(
                                itemCount: filteredQuizzes.length,
                                itemBuilder: (context, index) {
                                  final quiz = filteredQuizzes[index];
                                  return buildQuizCard(quiz);
                                },
                              ),
                    ),
                  ],
                ),
      ),
    );
  }
}
