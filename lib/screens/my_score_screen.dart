import 'package:flutter/material.dart';

class MyScoreScreen extends StatelessWidget {
  const MyScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'title': 'Questions répondues',
        'value': '128',
        'icon': Icons.quiz_outlined,
        'color': Colors.indigo.shade100,
      },
      {
        'title': 'Réussite 1er essai',
        'value': '72%',
        'icon': Icons.check_circle_outline,
        'color': Colors.green.shade100,
      },
      {
        'title': 'Réussite après 1 répétition',
        'value': '19%',
        'icon': Icons.replay_circle_filled_outlined,
        'color': Colors.orange.shade100,
      },
      {
        'title': 'Catégories suivies',
        'value': '6',
        'icon': Icons.category_outlined,
        'color': Colors.blue.shade100,
      },
      {
        'title': 'Score global',
        'value': '843 pts',
        'icon': Icons.star_outline,
        'color': Colors.yellow.shade100,
      },
      {
        'title': 'Sessions consécutives',
        'value': '14 jours',
        'icon': Icons.local_fire_department_outlined,
        'color': Colors.red.shade100,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mes scores',
          style: TextStyle(
            color: Color(0xFF3B3F9F),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF3B3F9F)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: stats.map((stat) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: stat['color'] as Color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      stat['icon'] as IconData,
                      size: 32,
                      color: const Color(0xFF3B3F9F),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stat['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            stat['value'] as String,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B3F9F),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}