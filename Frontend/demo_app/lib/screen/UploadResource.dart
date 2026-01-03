import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UploadResourceScreen extends StatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  State<UploadResourceScreen> createState() => _UploadResourceScreenState();
}

class _UploadResourceScreenState extends State<UploadResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _urlController = TextEditingController();
  final _topicController = TextEditingController();

  bool isSubmitting = false;

  Future<void> _submitResource() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token'); // assuming token is saved here

    final body = jsonEncode({
      'title': _titleController.text,
      'description': _descController.text,
      'url': _urlController.text,
      'topic': _topicController.text,
    });

    // ✅ Make the actual POST request here
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/resources/upload'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    setState(() {
      isSubmitting = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resource uploaded successfully!')),
      );
      _titleController.clear();
      _descController.clear();
      _urlController.clear();
      _topicController.clear();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: ${response.body}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('📤 Upload Resource'),
        backgroundColor: Colors.black12,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_titleController, 'Title'),
              _buildTextField(_descController, 'Description'),
              _buildTextField(_urlController, 'URL'),
              _buildTextField(_topicController, 'Topic (e.g. Music Theory)'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSubmitting ? null : _submitResource,
                child:
                    isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
}
