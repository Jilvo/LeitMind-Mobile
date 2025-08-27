import 'package:flutter/material.dart';
import '../services/scoring_service.dart';

class MyScoreScreen extends StatefulWidget {
  const MyScoreScreen({super.key});

  @override
  State<MyScoreScreen> createState() => _MyScoreScreenState();
}

class _MyScoreScreenState extends State<MyScoreScreen> {
  final ScoringService _scoringService = ScoringService();
  Map<String, dynamic>? scoringData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScoring();
  }

  Future<void> _loadScoring() async {
    try {
      final data = await _scoringService.getUserScoring();
      setState(() {
        scoringData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (scoringData == null) {
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
        body: const Center(
          child: Text(
            'Erreur lors du chargement des scores',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // Récupérer les catégories sous forme de chaîne
    final categories = scoringData!['category_subscribed'] as List<dynamic>? ?? [];
    final categoriesText = categories.isNotEmpty ? categories.join(', ') : 'Aucune';

    final stats = [
      {
        'title': 'Questions répondues',
        'value': '${scoringData!['responded_questions'] ?? 0}',
        'icon': Icons.quiz_outlined,
        'color': Colors.indigo.shade100,
      },
      {
        'title': 'Réussite 1er essai',
        'value': '${scoringData!['first_try_success_rate'] ?? 0}%',
        'icon': Icons.check_circle_outline,
        'color': Colors.green.shade100,
      },
      {
        'title': 'Réussite après 1 répétition',
        'value': '${scoringData!['success_after_first_retry'] ?? 0}%',
        'icon': Icons.replay_circle_filled_outlined,
        'color': Colors.orange.shade100,
      },
      {
        'title': 'Catégories suivies',
        'value': categoriesText,
        'icon': Icons.category_outlined,
        'color': Colors.blue.shade100,
      },
      {
        'title': 'Score global',
        'value': '${scoringData!['global_score'] ?? 0} pts',
        'icon': Icons.star_outline,
        'color': Colors.yellow.shade100,
      },
      {
        'title': 'Série de réponses',
        'value': '${scoringData!['consecutive_answer_streak'] ?? 0}',
        'icon': Icons.local_fire_department_outlined,
        'color': Colors.red.shade100,
      },
      {
        'title': 'Série globale',
        'value': '${scoringData!['global_streak'] ?? 0} jours',
        'icon': Icons.trending_up_outlined,
        'color': Colors.purple.shade100,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B3F9F),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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