// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _reenterPasswordController = TextEditingController();

//   bool _isPasswordVisible = false;
//   bool _isReenterPasswordVisible = false;

//   Future<void> resetPassword() async {
//     if (!_formKey.currentState!.validate()) return;

//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:8080/api/users/forgot-password'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'email': _emailController.text.trim(),
//         'newPassword': _passwordController.text,
//       }),
//     );

//     if (!mounted) return;

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Password reset successful')),
//       );
//       Navigator.pushReplacementNamed(context, '/login');
//     } else {
//       // Handle backend error
//       String errorMessage = 'Reset password failed';
//       try {
//         final body = json.decode(response.body);

//         // Try common fields in case backend sends JSON
//         errorMessage =
//             body['error'] ?? body['message'] ?? body['msg'] ?? errorMessage;
//       } catch (e) {
//         // If backend sends plain text
//         errorMessage = response.body;
//       }

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(errorMessage)));
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _reenterPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[900],
//       appBar: AppBar(
//         title: const Text(
//           "Forgot Password",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.grey[850],
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Image.asset(
//                   'assets/images/forgotpassword.png',
//                   width: 200,
//                   height: 200,
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   "Enter your email and new password to reset.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.grey[300], fontSize: 16),
//                 ),
//                 const SizedBox(height: 30),
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: _buildInputDecoration(
//                     label: 'Email',
//                     icon: Icons.email,
//                   ),
//                   validator: (val) {
//                     if (val == null || val.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
//                       return 'Please enter a valid email address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: _buildInputDecoration(
//                     label: 'New Password',
//                     icon: Icons.lock,
//                     isPassword: true,
//                     isVisible: _isPasswordVisible,
//                     toggleVisibility: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                   validator: (val) {
//                     if (val == null || val.isEmpty) {
//                       return 'Please enter a new password';
//                     }
//                     List<String> errors = [];
//                     if (val.length < 6)
//                       errors.add('• At least 6 characters long');
//                     if (!val.contains(RegExp(r'[0-9]')))
//                       errors.add('• At least one number');
//                     if (!val.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]')))
//                       errors.add('• At least one special character');

//                     if (errors.isNotEmpty) {
//                       return 'Password must contain:\n${errors.join('\n')}';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _reenterPasswordController,
//                   obscureText: !_isReenterPasswordVisible,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: _buildInputDecoration(
//                     label: 'Re-enter Password',
//                     icon: Icons.lock,
//                     isPassword: true,
//                     isVisible: _isReenterPasswordVisible,
//                     toggleVisibility: () {
//                       setState(() {
//                         _isReenterPasswordVisible = !_isReenterPasswordVisible;
//                       });
//                     },
//                   ),
//                   validator: (val) {
//                     if (val == null || val.isEmpty) {
//                       return 'Please re-enter your new password';
//                     }
//                     if (val != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       resetPassword();
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 5,
//                   ),
//                   child: const Text(
//                     "Reset Password",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _buildInputDecoration({
//     required String label,
//     required IconData icon,
//     bool isPassword = false,
//     bool isVisible = false,
//     VoidCallback? toggleVisibility,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(color: Colors.grey[400]),
//       hintStyle: TextStyle(color: Colors.grey[600]),
//       filled: true,
//       fillColor: Colors.grey[800],
//       prefixIcon: Icon(icon, color: Colors.green),
//       suffixIcon:
//           isPassword
//               ? IconButton(
//                 icon: Icon(
//                   isVisible ? Icons.visibility : Icons.visibility_off,
//                   color: Colors.grey[400],
//                 ),
//                 onPressed: toggleVisibility,
//               )
//               : null,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.green, width: 2),
//       ),
//       errorStyle: const TextStyle(color: Colors.redAccent),
//     );
//   }
// }
