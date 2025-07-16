import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/init_screen.dart'; // ← ajout ici

Future<void> main() async {
  await dotenv.load();
  runApp(const LeitMindApp());
}

class LeitMindApp extends StatelessWidget {
  const LeitMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeitMind',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const InitScreen(), // ← remplace initialRoute
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
