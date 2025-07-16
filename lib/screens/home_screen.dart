import 'package:flutter/material.dart';
import 'question_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "LeitMind",
          style: TextStyle(
            color: Color(0xFF3B3F9F),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          if (username.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: Colors.indigo.shade100,
                child: Text(
                  username.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF3B3F9F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bienvenue 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B3F9F),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Chaque jour, améliore ta mémoire grâce à la répétition espacée.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuestionScreen()),
                    );
                  },
                  icon: const Icon(Icons.book,color: Colors.white,),
                  label: const Text("Teste tes connaissances",style:TextStyle(color: Colors.white,)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B3F9F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Logique d’abonnement ou navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fonction 'S’abonner' à venir !")),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text("S’abonner à de nouveaux thèmes"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF3B3F9F)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    foregroundColor: const Color(0xFF3B3F9F),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
