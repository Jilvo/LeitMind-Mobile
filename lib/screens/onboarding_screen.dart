import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Illustration ou logo animé
            SizedBox(
              height: 180,
              child: Image.asset('assets/images/basic_mascotte.png', fit: BoxFit.contain), // à ajouter dans tes assets
            ),
            const SizedBox(height: 32),
            const Text(
              "Bienvenue sur LeitMind",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B3F9F), // indigo doux
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Ton entraînement cérébral quotidien ✨\nProgresse chaque jour grâce à la répétition espacée.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B3F9F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text("Se connecter",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF3B3F9F)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.person_add, color: Color(0xFF3B3F9F)),
                  label: const Text("Créer un compte",
                      style: TextStyle(fontSize: 16, color: Color(0xFF3B3F9F))),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  child: const Text("Continuer sans compte"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
