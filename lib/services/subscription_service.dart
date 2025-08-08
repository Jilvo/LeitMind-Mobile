import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/custom_http_client.dart';

class SubscriptionService {
  final String baseUrl = dotenv.env['API_URL']!;
  final http.Client client = CustomHttpClient();

  Future<List<Map<String, dynamic>>> getUserSubscriptions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getString('userId');

      if (token == null || userId == null) {
        throw Exception('Token ou utilisateur non trouvé');
      }

      final response = await client.get(
        Uri.parse('$baseUrl/subscription/subscriptions/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> subscriptions = data['subscription']['subscriptions'];
        return subscriptions.map((sub) => sub as Map<String, dynamic>).toList();
      } else {
        throw Exception('Erreur lors de la récupération des abonnements');
      }
    } catch (e) {
      print('Erreur SubscriptionService: $e');
      return [];
    }
  }

  Future<bool> updateUserSubscriptions(List<Map<String, dynamic>> subscriptions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getString('userId');

      if (token == null || userId == null) {
        throw Exception('Token ou utilisateur non trouvé');
      }

      final response = await client.post(
        Uri.parse('$baseUrl/subscription/subscriptions/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'subscriptions': subscriptions}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la mise à jour des abonnements: $e');
      return false;
    }
  }
}
