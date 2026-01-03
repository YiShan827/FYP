// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ResourcesScreen extends StatelessWidget {
//   const ResourcesScreen({super.key});

//   void _launchURL(String url) async {
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       throw 'Could not launch \$url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('🎓 Resources'),
//         backgroundColor: Colors.black12,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildResourceSection(
//             title: '🎼 Music Theory',
//             resources: [
//               {
//                 'title': 'Major & Minor Scales',
//                 'desc': 'Learn the basics of scales with examples.',
//                 'url': 'https://www.musictheory.net/lessons/21',
//               },
//               {
//                 'title': 'Circle of Fifths Explained',
//                 'desc': 'Understand key relationships visually.',
//                 'url': 'https://www.musictheory.net/lessons/30',
//               },
//             ],
//           ),
//           _buildResourceSection(
//             title: '🥁 Rhythm & Timing',
//             resources: [
//               {
//                 'title': 'Time Signatures 101',
//                 'desc': 'Get comfortable with different rhythmic patterns.',
//                 'url': 'https://www.musictheory.net/lessons/13',
//               },
//             ],
//           ),
//           _buildResourceSection(
//             title: '✍️ Composition Tips',
//             resources: [
//               {
//                 'title': 'How to Write Chord Progressions',
//                 'desc': 'Basic techniques for writing progressions.',
//                 'url': 'https://blog.landr.com/chord-progressions/',
//               },
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildResourceSection({
//     required String title,
//     required List<Map<String, String>> resources,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Colors.greenAccent,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         ...resources.map(
//           (res) => Card(
//             color: Colors.grey[900],
//             child: ListTile(
//               title: Text(
//                 res['title']!,
//                 style: const TextStyle(color: Colors.white),
//               ),
//               subtitle: Text(
//                 res['desc']!,
//                 style: const TextStyle(color: Colors.white70),
//               ),
//               trailing: const Icon(
//                 Icons.open_in_new,
//                 color: Colors.greenAccent,
//               ),
//               onTap: () => _launchURL(res['url']!),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  List<dynamic> _resources = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResources();
  }

  Future<void> fetchResources() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      print("🪪 JWT token in resources screen: $token");

      if (token == null) {
        throw Exception("JWT token not found.");
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/resources/resources'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("📡 Status: ${response.statusCode}");
      print("📄 Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _resources = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load resources');
      }
    } catch (e) {
      print('❌ Error fetching resources: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // ← FORCE open in external browser
    )) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Could not launch URL: $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('🎓 Resources'),
        backgroundColor: Colors.black12,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent),
              )
              : _resources.isEmpty
              ? const Center(
                child: Text(
                  'No resources available.',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                itemCount: _resources.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final section = _resources[index];
                  final topic = section['topic'] ?? 'Untitled Topic';
                  final sectionResources =
                      (section['resources'] is List)
                          ? section['resources'] as List
                          : [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          topic,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...sectionResources.map((resource) {
                        return Card(
                          color: Colors.grey[900],
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              resource['title'] ?? 'No Title',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              resource['description'] ?? 'No Description',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: const Icon(
                              Icons.open_in_new,
                              color: Colors.greenAccent,
                            ),
                            onTap: () => _launchURL(resource['url']),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
    );
  }
}
