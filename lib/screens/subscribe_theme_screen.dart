import 'package:flutter/material.dart';

class SubscribeThemesScreen extends StatefulWidget {
  const SubscribeThemesScreen({super.key});

  @override
  State<SubscribeThemesScreen> createState() => _SubscribeThemesScreenState();
}

class _SubscribeThemesScreenState extends State<SubscribeThemesScreen> {
  final List<Map<String, dynamic>> themes = [
    {
      'name': 'Histoire',
      'description':
          'Des origines à nos jours : explore les civilisations, les guerres et les révolutions.',
      'icon': Icons.history_edu_outlined,
    },
    {
      'name': 'Géographie',
      'description':
          'Découvre les continents, les pays, les capitales et les grands repères géo.',
      'icon': Icons.public_outlined,
    },
    {
      'name': 'Culture',
      'description':
          'Cinéma, littérature, art, musique : tout ce qui fait vibrer la société.',
      'icon': Icons.palette_outlined,
    },
    {
      'name': 'Géopolitique',
      'description':
          'Conflits, alliances, enjeux globaux : le monde d aujourd hui en perspective.',
      'icon': Icons.language_outlined,
    },
  ];

  final Set<String> subscribed = {'Histoire', 'Culture'};

  void toggleSubscription(String theme) {
    setState(() {
      if (subscribed.contains(theme)) {
        subscribed.remove(theme);
      } else {
        subscribed.add(theme);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'S abonner aux thèmes',
          style: TextStyle(
            color: Color(0xFF3B3F9F),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF3B3F9F)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          final isSubscribed = subscribed.contains(theme['name']);

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(theme['icon'], size: 32, color: Color(0xFF3B3F9F)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          theme['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Switch(
                        value: isSubscribed,
                        onChanged: (_) => toggleSubscription(theme['name']),
                        activeColor: Color(0xFF3B3F9F),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    theme['description'],
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
