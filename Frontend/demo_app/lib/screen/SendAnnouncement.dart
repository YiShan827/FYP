import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SendAnnouncementScreen extends StatefulWidget {
  const SendAnnouncementScreen({super.key});

  @override
  State<SendAnnouncementScreen> createState() => _SendAnnouncementScreenState();
}

class _SendAnnouncementScreenState extends State<SendAnnouncementScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool isSending = false;

  Future<void> sendAnnouncement() async {
    setState(() {
      isSending = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/announcements'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': _titleController.text.trim(),
        'message': _messageController.text.trim(),
      }),
    );

    setState(() {
      isSending = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Announcement sent")));
      _titleController.clear();
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: ${response.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Send Announcement"),
        backgroundColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        // 🔥 CHANGED: Added SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Message",
                labelStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isSending ? null : sendAnnouncement,
              icon: const Icon(Icons.send),
              label: Text(isSending ? "Sending..." : "Send Announcement"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // 🔥 OPTIONAL: Add some bottom padding for better scrolling
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
