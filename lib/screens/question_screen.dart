import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/question_service.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final QuestionService _questionService = QuestionService();
  
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;
  bool hasError = false;
  
  int? selectedIndex;
  bool showFeedback = false;
  List<Map<String, dynamic>> userAnswers = [];

  @override
  void initState() {
    super.initState();
    _loadDailyQuestions();
  }

  Future<void> _loadDailyQuestions() async {
    try {
      final dailyQuestions = await _questionService.getDailyQuestions();
      setState(() {
        questions = dailyQuestions;
        isLoading = false;
        hasError = dailyQuestions.isEmpty;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Map<String, dynamic>? get currentQuestion {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return null;
    }
    return questions[currentQuestionIndex];
  }

  List<Map<String, dynamic>> get currentAnswers {
    final question = currentQuestion;
    if (question == null) return [];
    return List<Map<String, dynamic>>.from(question['answers'] ?? []);
  }

  int get correctAnswerIndex {
    final answers = currentAnswers;
    for (int i = 0; i < answers.length; i++) {
      if (answers[i]['is_correct'] == true) {
        return i;
      }
    }
    return -1;
  }

  void _selectAnswer(int index) {
    if (selectedIndex != null) return;

    final question = currentQuestion;
    final answers = currentAnswers;
    
    if (question == null || answers.isEmpty) return;

    setState(() {
      selectedIndex = index;
      showFeedback = true;
    });

    // Stocker la réponse de l'utilisateur
    userAnswers.add({
      'question_id': question['id'],
      'selected_answer_id': answers[index]['id'],
      'is_correct': answers[index]['is_correct'],
    });
  }

  void _nextQuestion() async {
    // Valider la réponse avant de passer à la question suivante
    if (userAnswers.isNotEmpty) {
      final lastAnswer = userAnswers.last;
      final prefs = await SharedPreferences.getInstance();
      final userId = int.tryParse(prefs.getString('userId') ?? '0') ?? 0;
      
      await _questionService.validateAnswer(
        lastAnswer['question_id'],
        lastAnswer['selected_answer_id'],
        userId,
      );
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedIndex = null;
        showFeedback = false;
      });
    } else {
      // Toutes les questions terminées, afficher les résultats ou revenir
      _showResults();
    }
  }

  void _showResults() async {
    // Valider la dernière réponse si ce n'est pas déjà fait
    if (userAnswers.isNotEmpty) {
      final lastAnswer = userAnswers.last;
      final prefs = await SharedPreferences.getInstance();
      final userId = int.tryParse(prefs.getString('userId') ?? '0') ?? 0;
      
      await _questionService.validateAnswer(
        lastAnswer['question_id'],
        lastAnswer['selected_answer_id'],
        userId,
      );
    }

    final correctAnswers = userAnswers.where((answer) => answer['is_correct'] == true).length;
    final totalQuestions = userAnswers.length;
    
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Résultats'),
          content: Text('Vous avez obtenu $correctAnswers/$totalQuestions bonnes réponses !'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Retourner à l'écran précédent
              },
              child: const Text('Terminer'),
            ),
          ],
        ),
      );
    }
  }

  Color _cardColor(int index) {
    if (!showFeedback) return Colors.white;
    if (index == correctAnswerIndex) return Colors.green.shade100;
    if (index == selectedIndex) return Colors.red.shade100;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Question du jour",
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

    if (hasError || questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Question du jour",
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
            "Revenez demain",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final question = currentQuestion;
    final answers = currentAnswers;

    if (question == null) {
      return const Scaffold(
        body: Center(child: Text("Erreur de chargement")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Question ${currentQuestionIndex + 1}/${questions.length}",
          style: const TextStyle(
            color: Color(0xFF3B3F9F),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF3B3F9F)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['text'] ?? '',
              style: const TextStyle(
                fontSize: 22,
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
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: _cardColor(index),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF3B3F9F), width: 1.5),
                    ),
                    child: Text(
                      answers[index]['text'] ?? '',
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
            if (showFeedback) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF3B3F9F), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF3B3F9F)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question['explanation'] ?? 'Aucune explication disponible.',
                        style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (currentQuestionIndex < questions.length - 1)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B3F9F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Question suivante',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showResults,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Voir les résultats',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
