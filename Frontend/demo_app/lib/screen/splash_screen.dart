import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // 👇 make sure this key matches the one you used when saving token at login
    final token = prefs.getString('jwt_token');

    if (token != null && !_isTokenExpired(token)) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = base64Url.normalize(parts[1]);
      final decoded = json.decode(utf8.decode(base64Url.decode(payload)));

      final expiry = decoded['exp']; // JWT expiry in seconds
      final now =
          DateTime.now().millisecondsSinceEpoch ~/ 1000; // also in seconds

      return now > expiry;
    } catch (e) {
      return true; // assume expired on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Image.asset('assets/images/logo.png', width: 200, height: 200),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "🎼 Ready to level up your music theory? Let’s get started.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
