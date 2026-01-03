// lib/screens/post_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/forum_post.dart';
import '../models/forum_reply.dart';
import '../services/forum_api_service.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  ForumPost? post;
  List<ForumReply> replies = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _replyController = TextEditingController();
  bool isSubmittingReply = false;

  @override
  void initState() {
    super.initState();
    _loadPostAndReplies();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadPostAndReplies() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await ForumApiService.getPostWithReplies(widget.postId);

      setState(() {
        post = data['post'];
        replies = data['replies'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _addReply() async {
    if (_replyController.text.trim().isEmpty) {
      _showSnackBar('Please enter a reply', isError: true);
      return;
    }

    try {
      setState(() => isSubmittingReply = true);

      await ForumApiService.addReply(
        postId: widget.postId,
        content: _replyController.text.trim(),
      );

      _replyController.clear();
      _showSnackBar('Reply added successfully!');
      _loadPostAndReplies(); // Refresh to show new reply
    } catch (e) {
      _showSnackBar(
        'Failed to add reply: ${e.toString().replaceAll('Exception: ', '')}',
        isError: true,
      );
    } finally {
      setState(() => isSubmittingReply = false);
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
          post?.title ?? 'Post Details',
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.grey[900],
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.greenAccent),
            onPressed: _loadPostAndReplies,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPostAndReplies,
        color: Colors.greenAccent,
        backgroundColor: Colors.grey[800],
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildReplyInput(),
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
            Text('Loading post...', style: TextStyle(color: Colors.white70)),
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
              'Failed to load post',
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
              onPressed: _loadPostAndReplies,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (post == null) {
      return Center(
        child: Text(
          'Post not found',
          style: TextStyle(color: Colors.grey[400], fontSize: 18),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original post
          _buildPostCard(),

          SizedBox(height: 24),

          // Replies section
          Row(
            children: [
              Icon(Icons.comment, color: Colors.greenAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'Replies (${replies.length})',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Replies list
          if (replies.isEmpty)
            _buildNoRepliesWidget()
          else
            ...replies.map((reply) => _buildReplyCard(reply)).toList(),

          // Extra space for bottom input
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPostCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade900.withOpacity(0.3), Colors.grey[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post title
          Text(
            post!.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          SizedBox(height: 16),

          // Post content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              post!.content,
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            ),
          ),

          SizedBox(height: 16),

          // Post metadata
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.shade700.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.person, color: Colors.greenAccent, size: 16),
              ),
              SizedBox(width: 8),
              Text(
                post!.userName,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.access_time, color: Colors.grey[500], size: 16),
              SizedBox(width: 4),
              Text(
                _formatTime(post!.createdAt),
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoRepliesWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        children: [
          Icon(Icons.comment_outlined, color: Colors.grey[500], size: 48),
          SizedBox(height: 12),
          Text(
            'No replies yet',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Be the first to reply to this post!',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyCard(ForumReply reply) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply content
          Text(
            reply.content,
            style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
          ),

          SizedBox(height: 12),

          // Reply metadata
          Row(
            children: [
              Icon(Icons.person, color: Colors.grey[500], size: 14),
              SizedBox(width: 4),
              Text(
                reply.userName,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.access_time, color: Colors.grey[500], size: 14),
              SizedBox(width: 4),
              Text(
                _formatTime(reply.createdAt),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(top: BorderSide(color: Colors.grey[700]!)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _replyController,
                decoration: InputDecoration(
                  hintText: 'Write a reply...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.greenAccent),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                maxLines: null,
                maxLength: 500,
                enabled: !isSubmittingReply,
              ),
            ),
            SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: isSubmittingReply ? null : _addReply,
                icon:
                    isSubmittingReply
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Icon(Icons.send, color: Colors.white),
                tooltip: 'Send Reply',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
