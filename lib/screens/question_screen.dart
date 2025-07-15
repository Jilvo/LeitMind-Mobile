import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final question = "Quelle est la capitale de la France ?";
  final answers = ["Paris", "Lyon", "Marseille", "Nice"];
  final correctIndex = 0;
  final explanation = "Paris est la capitale de la France depuis le XVe siècle et le siège du gouvernement.";

  int? selectedIndex;
  bool showFeedback = false;

  void _selectAnswer(int index) {
    if (selectedIndex != null) return; // Évite double clic

    setState(() {
      selectedIndex = index;
      showFeedback = true;
    });
  }

  Color _cardColor(int index) {
    if (!showFeedback) return Colors.white;
    if (index == correctIndex) return Colors.green.shade100;
    if (index == selectedIndex) return Colors.red.shade100;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Question du jour",
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(answers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => _selectAnswer(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    decoration: BoxDecoration(
                      color: _cardColor(index),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigo, width: 1.5),
                    ),
                    child: Text(
                      answers[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (showFeedback)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.indigo),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        explanation,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
