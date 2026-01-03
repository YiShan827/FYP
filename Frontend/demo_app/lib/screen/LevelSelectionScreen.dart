// import 'package:flutter/material.dart';
// import 'quiz_screen.dart';

// class LevelSelectionScreen extends StatelessWidget {
//   final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Select Level")),
//       body: ListView.builder(
//         itemCount: levels.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(levels[index]),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => QuizScreen(level: levels[index]),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
