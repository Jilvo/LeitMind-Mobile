import 'package:flutter/material.dart';
import 'package:leitmind_mobile/screens/home_screen.dart';
// import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

class LeitMindApp extends StatelessWidget {
  const LeitMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeitMind',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeScreen(),
      // home: const LoginScreen(),
    );
  }
}
