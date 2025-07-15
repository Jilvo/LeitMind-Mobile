import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  final String question;
  final List<String> answers;
  final int correctIndex;

  const QuestionCard({
    super.key,
    required this.question,
    required this.answers,
    required this.correctIndex,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int? selected;

  void checkAnswer(int index) {
    setState(() {
      selected = index;
    });
    final isCorrect = index == widget.correctIndex;
    final message = isCorrect ? "Bonne réponse !" : "Faux !";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        ...List.generate(widget.answers.length, (index) {
          return ListTile(
            title: Text(widget.answers[index]),
            leading: Radio<int>(
              value: index,
              groupValue: selected,
              onChanged: (int? value) => checkAnswer(index),
            ),
          );
        }),
      ],
    );
  }
}
