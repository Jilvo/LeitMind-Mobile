import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/custom_http_client.dart';

class AttemptService {
  final String baseUrl = dotenv.env['API_URL']!;
  final http.Client client = CustomHttpClient();

  Future<List<Map<String, dynamic>>> getUserAttempts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getString('userId');

      if (token == null || userId == null) {
        throw Exception('Token ou utilisateur non trouvé');
      }

      final response = await client.get(
        Uri.parse('$baseUrl/attempt/attempts/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((attempt) => attempt as Map<String, dynamic>).toList();
      } else {
        throw Exception('Erreur lors de la récupération des tentatives');
      }
    } catch (e) {
      print('Erreur AttemptService: $e');
      return [];
    }
  }
}
