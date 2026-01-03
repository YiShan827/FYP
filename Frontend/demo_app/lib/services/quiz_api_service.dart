import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz.dart';
import '../models/quiz_session.dart';
import '../models/quiz_result.dart';
import '../models/user_stats.dart';

class QuizApiService {
  static const String baseUrl =
      'http://10.0.2.2:8080/api/quizzes'; // Change to your server URL

  // Get auth token from shared preferences
  static Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found. Please login again.');
    }
    return token;
  }

  // ===== EXISTING METHODS - Keep your current implementations =====

  Future<List<Quiz>> getBiteSizedQuizzes(String level) async {
    final response = await http.get(Uri.parse('$baseUrl/bite/$level'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((quiz) => Quiz.fromJson(quiz)).toList();
    } else {
      throw Exception('Failed to load bite-sized quizzes');
    }
  }

  static Future<List<Quiz>> getAllQuizzes() async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Quiz.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load quizzes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quizzes: $e');
    }
  }

  static Future<List<Quiz>> getQuizzesByLevel(
    String topic,
    String level,
  ) async {
    try {
      final token = await _getAuthToken(); // retrieve token
      final response = await http.get(
        Uri.parse('$baseUrl/$level'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Quiz.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load quizzes by level: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching quizzes by level: $e');
    }
  }

  static Future<List<String>> getTopicsByLevel(String level) async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/topics-by-level?level=$level'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<String>.from(data);
      } else {
        throw Exception('Failed to fetch topics');
      }
    } catch (e) {
      throw Exception('Error fetching topics: $e');
    }
  }

  static Future<List<Quiz>> getQuizzesByTopicAndLevel(
    String topic,
    String level,
  ) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/by-topic-and-level?topic=$topic&level=$level'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Quiz.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load quizzes by topic & level');
    }
  }

  static Future<List<Quiz>> getQuizzesByLevelOnly(String level) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$level'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Quiz.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load quizzes by level: ${response.statusCode}',
      );
    }
  }

  static Future<Quiz> createQuiz(Quiz quiz) async {
    try {
      final token = await _getAuthToken();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(quiz.toJson()),
      );

      if (response.statusCode == 200) {
        return Quiz.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating quiz: $e');
    }
  }

  // ===== NEW METHODS FOR ENHANCED QUIZ TAKING =====

  static Future<QuizSession> startQuiz(int quizId) async {
    try {
      final token = await _getAuthToken();
      final response = await http.post(
        Uri.parse('$baseUrl/$quizId/start'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return QuizSession.fromJson(responseData);
      } else if (response.statusCode == 404) {
        throw Exception('Quiz not found');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to start quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error starting quiz: $e');
    }
  }

  static Future<QuizResult> submitAnswer(int quizId, String answer) async {
    try {
      final token = await _getAuthToken();
      final response = await http.post(
        Uri.parse('$baseUrl/$quizId/submit-answer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'answer': answer}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return QuizResult.fromJson(responseData);
      } else if (response.statusCode == 404) {
        throw Exception('Quiz not found');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to submit answer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting answer: $e');
    }
  }

  static Future<UserStats> getUserStats() async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/my-stats'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return UserStats.fromJson(responseData);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to get user stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user stats: $e');
    }
  }

  // ===== HELPER METHODS =====

  static Future<bool> isTokenValid() async {
    try {
      await _getAuthToken();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // ===== LEGACY SUPPORT - Keep your existing submit method =====

  static Future<Map<String, dynamic>> submitQuizLegacy(
    List<int> selectedOptionIds,
    String levelName,
  ) async {
    try {
      final token = await _getAuthToken();
      final response = await http.post(
        Uri.parse('$baseUrl/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'selectedOptionIds': selectedOptionIds,
          'levelName': levelName,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting quiz: $e');
    }
  }
}
