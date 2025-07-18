import 'package:flutter/material.dart';

class AnswersHistoryScreen extends StatelessWidget {
  const AnswersHistoryScreen({super.key});

  final List<Map<String, dynamic>> history = const [
    {
      'question': 'Quelle est la capitale de la France ?',
      'correct': true,
      'answer': 'Paris',
    },
    {
      'question': 'En quelle année a commencé la Seconde Guerre mondiale ?',
      'correct': false,
      'answer': '1938',
    },
    {
      'question': 'Quel est le fleuve qui traverse Lyon ?',
      'correct': true,
      'answer': 'Le Rhône',
    },
    {
      'question': 'Qui a peint la Joconde ?',
      'correct': false,
      'answer': 'David Bowie',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Historique des réponses',
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
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          final isCorrect = item['correct'] as bool;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['question'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  isCorrect
                      ? Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        item['answer'],
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            item['answer'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
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
