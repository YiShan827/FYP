import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:demo_app/models/user_progress.dart';
import 'package:demo_app/screen/ManageQuizScreen.dart';
import 'package:demo_app/screen/ManageResourceScreen.dart';
import 'package:demo_app/screen/SendAnnouncement.dart';
import 'package:demo_app/screen/UploadResource.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  List<UserProgressX> _progressList = [];
  bool isLoadingProgress = true;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    fetchUserProgress();

    // Start animation after a brief delay to ensure widget is built
    Future.delayed(Duration(milliseconds: 100), () {
      _animationController?.forward();
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> fetchUserProgress() async {
    setState(() => isLoadingProgress = true); // Start loading

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/progress/admin/user-progress'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        setState(() {
          _progressList =
              body.map((json) => UserProgressX.fromJson(json)).toList();
          isLoadingProgress = false; // Loading complete
        });
      } else {
        setState(() => isLoadingProgress = false);
        print('Failed to load user progress');
      }
    } catch (e) {
      setState(() => isLoadingProgress = false);
      print('Error fetching user progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      _DashboardItem(
        label: 'Create Quiz',
        icon: Icons.library_add,
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.pushNamed(context, '/QuizScreen'),
      ),
      _DashboardItem(
        label: 'Manage Quizzes',
        icon: Icons.edit_note_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManageQuizzesScreen(),
              ),
            ),
      ),
      _DashboardItem(
        label: 'Manage Resource',
        icon: Icons.manage_search_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManageResourceScreen(),
              ),
            ),
      ),
      _DashboardItem(
        label: 'Send Announcement',
        icon: Icons.campaign,
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SendAnnouncementScreen(),
              ),
            ),
      ),
      _DashboardItem(
        label: 'Upload Resource',
        icon: Icons.upload_file,
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadResourceScreen(),
              ),
            ),
      ),
      _DashboardItem(
        label: 'Manage Announcements',
        icon: Icons.announcement,
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.pushNamed(context, '/manage-announcements'),
      ),
      _DashboardItem(
        label: 'Logout',
        icon: Icons.logout,
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () {
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
                      "Confirm Logout",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                content: const Text(
                  "Are you sure you want to logout?",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
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
                        "Logout",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('jwt_token');
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
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
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Admin Dashboard',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity:
                    _animationController ??
                    AnimationController(value: 1, vsync: this),
                child: SlideTransition(
                  position:
                      _animationController != null
                          ? Tween<Offset>(
                            begin: const Offset(-0.5, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController!,
                              curve: Curves.easeOutBack,
                            ),
                          )
                          : AlwaysStoppedAnimation(Offset.zero),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Welcome, Admin!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Manage your platform efficiently',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E1E1E).withOpacity(0.8),
                      const Color(0xFF2D2D2D).withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                              colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'User Progress Overview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child:
                          isLoadingProgress
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  strokeWidth: 2,
                                ),
                              )
                              : _progressList.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_off_outlined,
                                      color: Colors.white.withOpacity(0.5),
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No user progress available',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _progressList.length,
                                itemBuilder: (context, index) {
                                  final progress = _progressList[index];
                                  return Container(
                                    width: 200,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(
                                            0xFF2D2D2D,
                                          ).withOpacity(0.8),
                                          const Color(
                                            0xFF3D3D3D,
                                          ).withOpacity(0.6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundColor: Colors.blue
                                                    .withOpacity(0.2),
                                                child: Text(
                                                  (progress.username.isNotEmpty
                                                          ? progress.username[0]
                                                          : '?')
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  progress.username,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.quiz_outlined,
                                                color: Colors.green,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${progress.completedQuizzes} quizzes',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.emoji_events_outlined,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Level ${progress.level}',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Builder(
                builder: (context) {
                  final orientation = MediaQuery.of(context).orientation;
                  final crossAxisCount =
                      orientation == Orientation.landscape ? 3 : 2;
                  final rows = (actions.length / crossAxisCount).ceil();

                  // More generous height calculation
                  final screenWidth =
                      MediaQuery.of(context).size.width -
                      40; // Account for padding
                  final itemWidth =
                      (screenWidth - (16 * (crossAxisCount - 1))) /
                      crossAxisCount;
                  final itemHeight =
                      itemWidth / 1.1; // Based on childAspectRatio
                  final totalGridHeight =
                      (rows * itemHeight) +
                      ((rows - 1) * 16) +
                      20; // Add extra padding

                  return Container(
                    height: totalGridHeight,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children:
                          actions
                              .asMap()
                              .entries
                              .map(
                                (entry) => _buildSafeGridButton(
                                  context,
                                  entry.value,
                                  entry.key,
                                ),
                              )
                              .toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafeGridButton(
    BuildContext context,
    _DashboardItem action,
    int index,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: action.gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            try {
              action.onTap();
            } catch (e) {
              print('Navigation error: $e');
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(action.icon, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  action.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildGridButton(
    BuildContext context,
    _DashboardItem action,
    int index,
  ) {
    // Simple implementation without complex animations
    return Container(
      decoration: BoxDecoration(
        gradient: action.gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: action.onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(action.icon, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  action.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  _DashboardItem({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}

class UserProgressX {
  final String username;
  final int completedQuizzes;
  final String level;

  UserProgressX({
    required this.username,
    required this.completedQuizzes,
    required this.level,
  });

  factory UserProgressX.fromJson(Map<String, dynamic> json) {
    return UserProgressX(
      username: json['username'] ?? 'Unknown',
      completedQuizzes: json['completedQuizzes'] ?? 0,
      level: json['level'] ?? 'N/A',
    );
  }
}
