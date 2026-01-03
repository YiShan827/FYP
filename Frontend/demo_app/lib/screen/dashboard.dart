import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> _announcements = [];
  bool _isLoading = true;
  int completedQuizzes = 0;
  String userLevel = '';

  @override
  void initState() {
    super.initState();
    checkTokenAndRedirect();
    loadAnnouncements();
    fetchProgress();
  }

  void loadAnnouncements() async {
    try {
      final data = await fetchAnnouncements();
      setState(() {
        _announcements = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return {};
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    return json.decode(payload);
  }

  bool isTokenExpired(String token) {
    final payload = decodeJwt(token);
    final exp = payload['exp'];
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now > exp;
  }

  void checkTokenAndRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || isTokenExpired(token)) {
      await prefs.remove('jwt_token');
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<List<dynamic>> fetchAnnouncements() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/announcements'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load announcements');
    }
  }

  Future<void> fetchProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/progress'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        completedQuizzes = data['completedQuizzes'] ?? 0;
        userLevel = data['level'] ?? '';
      });
    } else {
      print('Failed to load progress: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔔 Announcements
            const Text(
              '📢 Announcements',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_announcements.isEmpty)
              const Text(
                "No announcements available",
                style: TextStyle(color: Colors.white70),
              )
            else
              SizedBox(
                // Estimate height for 2 announcement cards (adjust if needed)
                height: 180,
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6,
                  radius: const Radius.circular(10),
                  child: ListView.builder(
                    itemCount: _announcements.length,
                    itemBuilder: (context, index) {
                      final a = _announcements[index];
                      return Card(
                        color: Colors.blueGrey.shade800,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            a['title'] ?? 'No Title',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            a['message'] ?? 'No Content',
                            style: const TextStyle(color: Colors.white70),
                            maxLines: null,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // 📈 Progress
            const Text(
              'Your Progress',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              color: Colors.grey,
              child: ListTile(
                title: const Text(
                  'Completed Quizzes',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '$completedQuizzes',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.grey,
              child: ListTile(
                title: const Text(
                  'Level',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  userLevel,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text(
                  'Go to Home',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
