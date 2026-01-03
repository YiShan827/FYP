import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/forum_category.dart';
import '../models/forum_post.dart';
import '../models/forum_reply.dart';

class ForumApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/forum';

  // Get JWT token for authentication
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Get common headers with auth
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get all forum categories
  static Future<List<ForumCategory>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ForumCategory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }

  // Get posts in a specific category
  static Future<List<ForumPost>> getPosts(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?categoryId=$categoryId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ForumPost.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading posts: $e');
    }
  }

  // Get specific post with replies
  static Future<Map<String, dynamic>> getPostWithReplies(int postId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$postId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'post': ForumPost.fromJson(data['post']),
          'replies':
              (data['replies'] as List)
                  .map((json) => ForumReply.fromJson(json))
                  .toList(),
        };
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading post: $e');
    }
  }

  // Create a new post
  static Future<ForumPost> createPost({
    required int categoryId,
    required String title,
    required String content,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: headers,
        body: jsonEncode({
          'categoryId': categoryId,
          'title': title,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        return ForumPost.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Please login to create posts');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to create post');
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  // Add a reply to a post
  static Future<ForumReply> addReply({
    required int postId,
    required String content,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/replies'),
        headers: headers,
        body: jsonEncode({'postId': postId, 'content': content}),
      );

      if (response.statusCode == 201) {
        return ForumReply.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Please login to add replies');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to add reply');
      }
    } catch (e) {
      throw Exception('Error adding reply: $e');
    }
  }

  // Search posts
  static Future<List<ForumPost>> searchPosts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?q=${Uri.encodeComponent(query)}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ForumPost.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching posts: $e');
    }
  }
}
