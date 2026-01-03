import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String userName = 'User';
  List<dynamic> _announcements = [];
  bool _isLoadingAnnouncements = true;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  int totalQuizzes = 0;
  double averageScore = 0.0;
  int correctAnswers = 0;
  bool isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadAnnouncements();

    try {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this,
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
      );
      _animationController?.forward();
    } catch (e) {
      // Animation setup failed, continue without animations
      print('Animation setup failed: $e');
    }

    _loadUserStats();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _loadUserStats() async {
    print('🚀 _loadUserStats called');
    try {
      setState(() {
        isLoadingStats = true;
        print('🔄 Set isLoadingStats = true');
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      print('🔑 Token exists: ${token != null}');
      if (token != null) {
        print('🔑 Token preview: ${token.substring(0, 20)}...');
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/quizzes/my-stats'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🧩 Parsed data: $data');
        print('🧩 totalAttempts: ${data['totalAttempts']}');
        print('🧩 accuracy: ${data['accuracy']}');
        print('🧩 correctAnswers: ${data['correctAnswers']}');

        setState(() {
          totalQuizzes = data['totalAttempts'] ?? 0;
          averageScore = (data['accuracy'] ?? 0).toDouble();
          correctAnswers = data['correctAnswers'] ?? 0;
          isLoadingStats = false;
          print(
            '✅ Updated state - totalQuizzes: $totalQuizzes, averageScore: $averageScore, correctAnswers: $correctAnswers',
          );
        });
      } else {
        print(
          '❌ API Error: Status ${response.statusCode}, Body: ${response.body}',
        );
        setState(() => isLoadingStats = false);
      }
    } catch (e, stackTrace) {
      print('❌ Exception: $e');
      print('❌ Stack trace: $stackTrace');
      setState(() => isLoadingStats = false);
    }
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'User';
    });
  }

  Future<void> _loadAnnouncements() async {
    try {
      final data = await fetchAnnouncements();
      setState(() {
        _announcements = data;
        _isLoadingAnnouncements = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingAnnouncements = false;
      });
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '🌅';
    if (hour < 17) return '☀️';
    return '🌙';
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'label': 'Start Quiz',
        'route': '/quizLevels',
        'subtitle': 'Test your knowledge',
        'emoji': '🎵',
        'color': const Color(0xFF64B5F6),
      },
      {
        'label': 'Progress',
        'route': '/progress',
        'subtitle': 'Track your scores',
        'emoji': '📊',
        'color': const Color(0xFF81C784),
      },
      {
        'label': 'Forum',
        'route': '/forum',
        'subtitle': 'Discuss & Learn',
        'emoji': '💬',
        'color': const Color(0xFFFFB74D),
      },
      {
        'label': 'Resources',
        'route': '/resources',
        'subtitle': 'Study materials',
        'emoji': '📚',
        'color': const Color(0xFFBA68C8),
      },
      {
        'label': 'Logout',
        'subtitle': 'Sign out safely',
        'emoji': '🚪',
        'color': const Color(0xFFEF5350),
        'action': () => _showLogoutDialog(),
      },
    ];

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
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Music Quiz Home',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadAnnouncements();
            await _loadUserStats(); // ✅ Add this
          },
          color: Colors.blue,
          backgroundColor: const Color(0xFF2D2D2D),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child:
                _fadeAnimation != null
                    ? FadeTransition(
                      opacity: _fadeAnimation!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhanced Welcome Section
                          _buildWelcomeSection(),
                          const SizedBox(height: 32),

                          // Quick Stats Section
                          _buildQuickStats(),
                          const SizedBox(height: 32),

                          // Announcements Section
                          _buildAnnouncementsSection(),
                          const SizedBox(height: 32),

                          // Menu Items Section
                          _buildMenuSection(menuItems),
                          const SizedBox(height: 32),
                        ],
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Enhanced Welcome Section
                        _buildWelcomeSection(),
                        const SizedBox(height: 32),

                        // Quick Stats Section
                        _buildQuickStats(),
                        const SizedBox(height: 32),

                        // Announcements Section
                        _buildAnnouncementsSection(),
                        const SizedBox(height: 32),

                        // Menu Items Section
                        _buildMenuSection(menuItems),
                        const SizedBox(height: 32),
                      ],
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _getGreetingEmoji(),
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()}, $userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to enhance your music skills today?',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        color: Colors.green,
                        size: 8,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.green.shade300,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            isLoadingStats ? '...' : '$totalQuizzes',
            'Questions\nAttempted',
            Icons.quiz_outlined,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            isLoadingStats ? '...' : '${averageScore.toStringAsFixed(1)}%',
            'Accuracy',
            Icons.trending_up,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            isLoadingStats ? '...' : '$correctAnswers',
            'Correct\nAnswers', // ✅ Replaced "Day Streak"
            Icons.check_circle_outline, // ✅ Replaced fire icon
            Colors.purple, // ✅ Changed color from orange to purple
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
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
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsSection() {
    return Column(
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
              child: const Icon(Icons.campaign, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            const Text(
              'Latest Announcements',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 16),

        if (_isLoadingAnnouncements)
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2D2D2D).withOpacity(0.8),
                  const Color(0xFF3D3D3D).withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          )
        else if (_announcements.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  color: Colors.white.withOpacity(0.5),
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  "No announcements available",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            height: 200,
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
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _announcements.length,
              itemBuilder: (context, index) {
                final announcement = _announcements[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1E1E1E).withOpacity(0.8),
                        const Color(0xFF2D2D2D).withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.announcement,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ),
                    title: Text(
                      announcement['title'] ?? 'No Title',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      announcement['message'] ?? 'No Content',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _showAnnouncementDialog(announcement),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildMenuSection(List<Map<String, dynamic>> menuItems) {
    return Column(
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
                Icons.dashboard_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Quick Actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3.0,
          children: menuItems.map((item) => _buildMenuItem(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2D2D2D).withOpacity(0.8),
              const Color(0xFF3D3D3D).withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap:
                item['action'] ??
                () => Navigator.pushNamed(context, item['route']),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: item['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['emoji'],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['label'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item['subtitle'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAnnouncementDialog(Map<String, dynamic> announcement) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.campaign, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    announcement['title'] ?? 'Announcement',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            content: Text(
              announcement['message'] ?? 'No content',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog() {
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
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                "Confirm Logout",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('isLoggedIn');
                  await prefs.remove('jwt_token');
                  await prefs.remove('userName');

                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
