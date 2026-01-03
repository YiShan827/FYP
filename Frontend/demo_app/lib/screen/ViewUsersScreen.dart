import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// If you save the model separately

class ViewUsersScreen extends StatefulWidget {
  const ViewUsersScreen({super.key});

  @override
  State<ViewUsersScreen> createState() => _ViewUsersScreenState();
}

class _ViewUsersScreenState extends State<ViewUsersScreen> {
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    final res = await http.get(
      Uri.parse('http://localhost:8080/api/admin/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      setState(() {
        _users = data.map((json) => UserModel.fromJson(json)).toList();
      });
    } else {
      print('❌ Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("View Users"),
        backgroundColor: Colors.black,
      ),
      body:
          _users.isEmpty
              ? const Center(
                child: Text(
                  "No users available",
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        user.email,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Role: ${user.role}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

class UserModel {
  final int id;
  final String email;
  final String role;

  UserModel({required this.id, required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email'], role: json['role']);
  }
}
