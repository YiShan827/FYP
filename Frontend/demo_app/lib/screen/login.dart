import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // for SocketException
import 'dart:async'; // for TimeoutException

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final url = Uri.parse('http://10.0.2.2:8080/api/users/login');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(Duration(seconds: 10)); // Add timeout

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        final name = responseData['user']['name'];

        final parts = token.split('.');
        if (parts.length != 3) throw Exception('Invalid JWT token');
        await prefs.setString('userName', name);

        final payload = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );
        final role = payload['role']?.toUpperCase();

        print('User role: $role');

        if (!mounted) return;

        if (role == 'ADMIN') {
          Navigator.pushReplacementNamed(context, '/AdminDashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          final errorMessage =
              errorResponse['message'] ??
              errorResponse['error'] ??
              response.body;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. ${response.body}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection. Please check your network.'),
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => handleLogin(),
          ),
        ),
      );
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection timeout. Please try again.'),
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => handleLogin(),
          ),
        ),
      );
    } catch (e) {
      print('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true, // Important for keyboard push
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60), // Top spacing
              Image.asset('assets/images/logo.png', height: 200),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: handleLogin,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(context, '/register'),
                child: const Text(
                  'Don\'t have an account? Register here',
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/emailForgotPassword');
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 40), // Bottom breathing room
            ],
          ),
        ),
      ),
    );
  }
}
