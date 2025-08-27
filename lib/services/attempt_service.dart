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

      print('🔄 Récupération des tentatives pour userId: $userId');
      print('🔑 Token disponible: ${token.isNotEmpty}');
      final url = '$baseUrl/attempt/attempts/user/$userId';
      print('🌐 URL: $url');

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Forcer l'encodage UTF-8 pour les caractères spéciaux
        final String responseBody = utf8.decode(response.bodyBytes);
        print('📄 Response Body: $responseBody');
        
        // La réponse est un objet avec une clé "attempts" qui contient l'array
        final Map<String, dynamic> data = jsonDecode(responseBody);
        
        if (data['attempts'] == null) {
          print('⚠️  Pas de clé "attempts" dans la réponse');
          return [];
        }
        
        final List<dynamic> attempts = data['attempts'];
        print('📋 Tentatives récupérées: ${attempts.length}');
        return attempts.map((attempt) => attempt as Map<String, dynamic>).toList();
      } else {
        print('❌ Erreur HTTP: ${response.statusCode} - ${response.body}');
        throw Exception('Erreur lors de la récupération des tentatives');
      }
    } catch (e) {
      print('💥 Erreur AttemptService: $e');
      return [];
    }
  }
}
