import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../services/custom_http_client.dart';

class AuthService {
  final String baseUrl = dotenv.env['API_URL']!;
  final http.Client client = CustomHttpClient();

  Future<(bool, String)> login(String email, String password) async {
    try {
      final res = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(res.body);
      final rawDetail = data["detail"]["message"];
      print("Raw detail: $data");
      final detail = rawDetail is String ? rawDetail : "Erreur inconnue";

      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final token = data['access_token'];
        await prefs.setString('token', token);
        return (true, "Connexion réussie");
      }

      return (false, detail);
    } catch (e) {
      return (false, "Erreur de connexion");
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final res = await client.post(
        Uri.parse('$baseUrl/auth/register'),
        body: jsonEncode({'email': email, 'password': password}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
