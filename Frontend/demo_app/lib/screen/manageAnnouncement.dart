import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ManageAnnouncementsScreen extends StatefulWidget {
  const ManageAnnouncementsScreen({super.key});

  @override
  State<ManageAnnouncementsScreen> createState() =>
      _ManageAnnouncementsScreenState();
}

class _ManageAnnouncementsScreenState extends State<ManageAnnouncementsScreen> {
  List<dynamic> _announcements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/announcements'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _announcements = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load announcements')));
    }
  }

  Future<void> _deleteAnnouncement(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8080/api/announcements/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _announcements.removeWhere((a) => a['id'] == id);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Announcement deleted')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete announcement')));
    }
  }

  void _confirmDelete(BuildContext context, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Confirm Deletion',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to delete this announcement?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await _deleteAnnouncement(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('📢 Manage Announcements'),
        backgroundColor: Colors.black12,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _announcements.isEmpty
              ? const Center(
                child: Text(
                  'No announcements found.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                itemCount: _announcements.length,
                itemBuilder: (context, index) {
                  final ann = _announcements[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        ann['title'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        ann['message'],
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _confirmDelete(context, ann['id']),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
