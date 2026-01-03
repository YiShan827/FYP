import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  final _answerController = TextEditingController();
  final _topicController = TextEditingController();
  final _feedbackController =
      TextEditingController(); // Added feedback controller

  String? _selectedLevel;
  bool _isSubmitting = false;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _questionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    _option4Controller.dispose();
    _answerController.dispose();
    _topicController.dispose();
    _feedbackController.dispose(); // Dispose feedback controller
    super.dispose();
  }

  Future<void> _submitQuiz() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('User not authenticated'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/quizzes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'question': _questionController.text.trim(),
          'optionA': _option1Controller.text.trim(),
          'optionB': _option2Controller.text.trim(),
          'optionC': _option3Controller.text.trim(),
          'optionD': _option4Controller.text.trim(),
          'correctAnswer': _answerController.text.trim().toUpperCase(),
          'level': _selectedLevel?.toLowerCase(),
          'topic': _topicController.text.trim(),
          'feedback': _feedbackController.text.trim(), // Added feedback field
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Quiz created successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        _clearForm();
      } else {
        throw Exception('Failed to create quiz: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Failed to create quiz: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _clearForm() {
    _questionController.clear();
    _option1Controller.clear();
    _option2Controller.clear();
    _option3Controller.clear();
    _option4Controller.clear();
    _answerController.clear();
    _topicController.clear();
    _feedbackController.clear(); // Clear feedback field
    setState(() {
      _selectedLevel = null;
    });
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E1E1E).withOpacity(0.8),
            const Color(0xFF2D2D2D).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          filled: true,
          fillColor: const Color(0xFF2D2D2D).withOpacity(0.5),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF64B5F6), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          if (label.contains('Correct Answer')) {
            String answer = value.trim().toUpperCase();
            if (!['A', 'B', 'C', 'D'].contains(answer)) {
              return 'Answer must be A, B, C, or D';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: DropdownButtonFormField<String>(
          value: _selectedLevel,
          dropdownColor: const Color(0xFF2D2D2D),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: const InputDecoration(
            labelText: 'Difficulty Level',
            labelStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
          items:
              ['Beginner', 'Intermediate', 'Expert'].map((level) {
                IconData icon;
                Color color;
                switch (level) {
                  case 'Beginner':
                    icon = Icons.stars;
                    color = Colors.green;
                    break;
                  case 'Intermediate':
                    icon = Icons.trending_up;
                    color = Colors.orange;
                    break;
                  default:
                    icon = Icons.emoji_events;
                    color = Colors.red;
                }

                return DropdownMenuItem(
                  value: level,
                  child: Row(
                    children: [
                      Icon(icon, color: color, size: 20),
                      const SizedBox(width: 8),
                      Text(level),
                    ],
                  ),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLevel = value;
            });
          },
          validator:
              (value) =>
                  value == null ? 'Please select a difficulty level' : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              ),
              child: const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Create Quiz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Clear Form',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Are you sure you want to clear all fields?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _clearForm();
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Basic Information Section
              _buildSection('Basic Information', Icons.info_outline, [
                _buildTextField(
                  _topicController,
                  'Topic',
                  hint: 'e.g., Music, Music composition',
                ),
                _buildDropdown(),
              ]),

              // Question Section
              _buildSection('Question', Icons.help_outline, [
                _buildTextField(
                  _questionController,
                  'Question',
                  hint: 'Enter your quiz question here',
                  maxLines: 3,
                ),
              ]),

              // Answer Options Section
              _buildSection('Answer Options', Icons.list_alt, [
                _buildTextField(_option1Controller, 'Option A'),
                _buildTextField(_option2Controller, 'Option B'),
                _buildTextField(_option3Controller, 'Option C'),
                _buildTextField(_option4Controller, 'Option D'),
              ]),

              // Correct Answer Section
              _buildSection('Correct Answer', Icons.check_circle_outline, [
                _buildTextField(
                  _answerController,
                  'Correct Answer',
                  hint: 'Enter A, B, C, or D',
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Specify which option (A, B, C, or D) is the correct answer',
                          style: TextStyle(
                            color: Colors.blue.shade200,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              // Feedback/Explanation Section
              _buildSection('Explanation', Icons.lightbulb_outline, [
                _buildTextField(
                  _feedbackController,
                  'Feedback',
                  hint:
                      'Explain why this answer is correct (helps students learn)',
                  maxLines: 4,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.tips_and_updates,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Provide a clear explanation to help students understand the concept',
                          style: TextStyle(
                            color: Colors.green.shade200,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // Submit Button
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed:
                      _isSubmitting
                          ? null
                          : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _submitQuiz();
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:
                      _isSubmitting
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Creating Quiz...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF64B5F6),
                                      Color(0xFF2196F3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.add_task,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Create Quiz',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
