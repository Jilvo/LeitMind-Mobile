import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/custom_http_client.dart';

class ScoringService {
  final String baseUrl = dotenv.env['API_URL']!;
  final http.Client client = CustomHttpClient();

  Future<Map<String, dynamic>?> getUserScoring() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token non trouvé');
      }

      print('🔄 Récupération du scoring utilisateur...');
      final url = '$baseUrl/questions/user_scoring/';
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
        
        final Map<String, dynamic> data = jsonDecode(responseBody);
        print('📊 Scoring récupéré: $data');
        return data["message"];
      } else {
        print('❌ Erreur HTTP: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('💥 Erreur ScoringService: $e');
      return null;
    }
  }
}
