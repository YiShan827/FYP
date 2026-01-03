import 'package:flutter/material.dart';

class ThreadDetailScreen extends StatelessWidget {
  final String threadTitle;

  const ThreadDetailScreen({super.key, required this.threadTitle});

  @override
  Widget build(BuildContext context) {
    final List<String> replies = [
      'A triad is a three-note chord.',
      'Usually consists of root, third, and fifth.',
    ];

    final TextEditingController replyController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(threadTitle),
        backgroundColor: Colors.black12,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Original post content goes here...',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Divider(color: Colors.white24),
          Expanded(
            child: ListView.builder(
              itemCount: replies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    replies[index],
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: replyController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Write a reply...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    // TODO: send reply via API
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
