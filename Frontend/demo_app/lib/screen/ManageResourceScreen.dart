import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ManageResourceScreen extends StatefulWidget {
  const ManageResourceScreen({super.key});

  @override
  State<ManageResourceScreen> createState() => _ManageResourcesScreenState();
}

class _ManageResourcesScreenState extends State<ManageResourceScreen> {
  List<dynamic> groupedResources = [];
  String? selectedTopic;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResources();
  }

  Future<void> fetchResources() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/resources/resources'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        groupedResources = json.decode(response.body);
        selectedTopic =
            groupedResources.isNotEmpty ? groupedResources[0]['topic'] : null;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print("❌ Failed to load resources: ${response.body}");
    }
  }

  Future<void> deleteResource(int resourceId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8080/api/resources/resources/$resourceId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Resource deleted")));
      fetchResources();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete resource: ${response.body}")),
      );
    }
  }

  void confirmDelete(int resourceId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              "Confirm Deletion",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Are you sure you want to delete this resource?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  deleteResource(resourceId); // Proceed with deletion
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedGroup = groupedResources.firstWhere(
      (group) => group['topic'] == selectedTopic,
      orElse: () => {'resources': []},
    );

    final resources = selectedGroup['resources'] as List<dynamic>;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Manage Resources"),
        backgroundColor: Colors.black12,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey[900],
                      value: selectedTopic,
                      onChanged: (newValue) {
                        setState(() => selectedTopic = newValue);
                      },
                      items:
                          groupedResources.map<DropdownMenuItem<String>>((
                            group,
                          ) {
                            return DropdownMenuItem<String>(
                              value: group['topic'],
                              child: Text(
                                group['topic'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  Expanded(
                    child:
                        resources.isEmpty
                            ? const Center(
                              child: Text(
                                "No resources available",
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                            : ListView.builder(
                              itemCount: resources.length,
                              itemBuilder: (context, index) {
                                final resource = resources[index];
                                return Card(
                                  color: Colors.grey[900],
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      resource['title'] ?? 'No Title',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      resource['description'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed:
                                          () => confirmDelete(resource['id']),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
