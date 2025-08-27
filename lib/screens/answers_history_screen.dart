import 'package:flutter/material.dart';
import '../services/attempt_service.dart';

class AnswersHistoryScreen extends StatefulWidget {
  const AnswersHistoryScreen({super.key});

  @override
  State<AnswersHistoryScreen> createState() => _AnswersHistoryScreenState();
}

class _AnswersHistoryScreenState extends State<AnswersHistoryScreen> {
  final AttemptService _attemptService = AttemptService();
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttempts();
  }

  Future<void> _loadAttempts() async {
    try {
      final attempts = await _attemptService.getUserAttempts();
      setState(() {
        history = attempts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? const Center(
                  child: Text(
                    'Vous n\'avez répondu à aucune question',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          print('📄 Item $index: $item');

          final isCorrect = item['is_correct'] as bool? ?? false;
          final question = item['question']?.toString() ?? 'Question non disponible';
          final answer = item['answer']?.toString() ?? 'Réponse non disponible';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
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
                        answer,
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
                            answer,
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
