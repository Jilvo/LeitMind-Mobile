import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/custom_http_client.dart';

class QuestionService {
  final String baseUrl = dotenv.env['API_URL']!;
  final http.Client client = CustomHttpClient();

  Future<List<Map<String, dynamic>>> getDailyQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token non trouvé');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/questions/questions/daily_questions'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Forcer l'encodage UTF-8 pour les caractères spéciaux
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(responseBody);
      print('Response data: $data'); // Debug log

      // La réponse utilise 'daily_questions' au lieu de 'message'
      if (data['daily_questions'] == null) {
        print('Warning: daily_questions is null in response');
        return [];
      }

      if (data['daily_questions'] is! List) {
        print('Warning: daily_questions is not a List, it is: ${data['daily_questions'].runtimeType}');
        return [];
      }

      final List<dynamic> questions = data['daily_questions'];
      return questions.map((q) => q as Map<String, dynamic>).toList();
    } else {
      print('HTTP Error: ${response.statusCode} - ${response.body}');
      throw response;
    }
  }

  Future<bool> validateAnswer(int questionId, int answerId, int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await client.post(
        Uri.parse('$baseUrl/validate/validate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'question_id': questionId,
          'answer_id': answerId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        print('Answer validated successfully');
        return true;
      } else {
        print('Validation error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erreur validation: $e');
      return false;
    }
  }
}
