// lib/screens/posts_list_screen.dart
import 'package:flutter/material.dart';
import '../models/forum_category.dart';
import '../models/forum_post.dart';
import '../services/forum_api_service.dart';
import 'post_detail_screen.dart';

class PostsListScreen extends StatefulWidget {
  final ForumCategory category;

  const PostsListScreen({Key? key, required this.category}) : super(key: key);

  @override
  _PostsListScreenState createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  List<ForumPost> posts = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final loadedPosts = await ForumApiService.getPosts(widget.category.id);

      setState(() {
        posts = loadedPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _showCreatePostDialog() async {
    _titleController.clear();
    _contentController.clear();

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.add_comment, color: Colors.greenAccent),
                SizedBox(width: 8),
                Text('Create New Post', style: TextStyle(color: Colors.white)),
              ],
            ),
            content: Container(
              width: double.maxFinite,
              height:
                  MediaQuery.of(context).size.height *
                  0.5, // Limit height to 50% of screen
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[600]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.greenAccent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      maxLength: 100,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[600]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.greenAccent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      maxLines: 4,
                      maxLength: 1000,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              ElevatedButton(
                onPressed: _createPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Create Post',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _createPost() async {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      _showSnackBar('Please fill in both title and content', isError: true);
      return;
    }

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            ),
      );

      await ForumApiService.createPost(
        categoryId: widget.category.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );

      Navigator.pop(context); // Close loading
      Navigator.pop(context); // Close dialog

      _showSnackBar('Post created successfully!');
      _loadPosts(); // Refresh posts
    } catch (e) {
      Navigator.pop(context); // Close loading
      _showSnackBar(
        'Failed to create post: ${e.toString().replaceAll('Exception: ', '')}',
        isError: true,
      );
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[900],
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.greenAccent),
            onPressed: _loadPosts,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPosts,
        color: Colors.greenAccent,
        backgroundColor: Colors.grey[800],
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        backgroundColor: Colors.green.shade700,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Create New Post',
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.greenAccent),
            SizedBox(height: 16),
            Text('Loading posts...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
            SizedBox(height: 16),
            Text(
              'Failed to load posts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage!.replaceAll('Exception: ', ''),
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPosts,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add, color: Colors.grey[500], size: 64),
            SizedBox(height: 16),
            Text(
              'No posts yet',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Be the first to start a discussion!',
              style: TextStyle(color: Colors.grey[500]),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showCreatePostDialog,
              icon: Icon(Icons.add),
              label: Text('Create First Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(ForumPost post) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(postId: post.id),
            ),
          ).then((_) => _loadPosts()); // Refresh when returning
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[900]!, Colors.grey[850]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[700]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post title
              Text(
                post.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 8),

              // Post content preview
              Text(
                post.content,
                style: TextStyle(color: Colors.grey[300], fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12),

              // Post metadata
              Row(
                children: [
                  Icon(Icons.person, color: Colors.greenAccent, size: 16),
                  SizedBox(width: 4),
                  Text(
                    post.userName,
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.access_time, color: Colors.grey[500], size: 16),
                  SizedBox(width: 4),
                  Text(
                    _formatTime(post.createdAt),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  Spacer(),
                  if (post.replyCount > 0) ...[
                    Icon(Icons.comment, color: Colors.grey[500], size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${post.replyCount}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
