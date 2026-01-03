import 'package:demo_app/screen/ForgotPasswordEmailScreen.dart';
import 'package:demo_app/screen/ManageResourceScreen.dart';
import 'package:demo_app/screen/ResetPasswordScreen.dart';
import 'package:demo_app/screen/manageAnnouncement.dart';
import 'package:demo_app/screen/quiz_list.dart';
import 'package:demo_app/screen/splash_screen.dart';
import 'package:demo_app/screen/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/screen/HomeScreen.dart';
import 'package:demo_app/screen/ForumScreen.dart';
import 'package:demo_app/screen/NewThreadScreen.dart';
// import 'package:demo_app/screen/screen1.dart';
import 'package:demo_app/screen/login.dart';
// import 'package:demo_app/screen/dashboard.dart';
import 'package:demo_app/screen/resources.dart';
import 'package:demo_app/screen/RegisterScreen.dart';
import 'package:demo_app/screen/create_quiz_screen.dart';
import 'package:demo_app/screen/admin_dashboard.dart';
// import 'package:demo_app/screen/ForgotPasswordScreen.dart';
import 'package:demo_app/screen/UploadResource.dart';

void main() {
  runApp(const MyApp()); // ✅ Important
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Quiz App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/forum': (context) => const ForumHomeScreen(),
        '/newThread': (context) => const NewThreadScreen(),
        '/quizLevels': (context) => QuizListScreen(),
        '/progress': (context) => DarkStatsScreen(),
        '/resources': (context) => const ResourcesScreen(),
        '/logOut': (context) => const LoginScreen(),
        '/QuizScreen': (context) => const CreateQuizScreen(),
        '/AdminDashboard': (context) => const AdminDashboard(),
        // '/forgotPassword': (context) => const ForgotPasswordScreen()
        'uploadResource': (context) => const UploadResourceScreen(),
        '/manageResource': (context) => const ManageResourceScreen(),
        '/emailForgotPassword': (context) => const ForgotPasswordEmailScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/manage-announcements': (context) => const ManageAnnouncementsScreen(),
      },
    );
  }
}
