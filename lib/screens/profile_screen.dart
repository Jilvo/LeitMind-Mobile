import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String email = '';
  String? avatarUrl;
  String? userId;

  File? _selectedImage;
  final String baseUrl = dotenv.env['API_URL']!;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username") ?? 'Utilisateur';
      email = prefs.getString("email") ?? 'email@exemple.com';
      avatarUrl = prefs.getString("avatarUrl") ?? null;
      userId = prefs.getString("userId") ?? '';
    });
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      await fetchAvatarUrlFromApi();
    }
  }
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85); // compression
    if (picked != null) {
      final imageFile = File(picked.path);
      setState(() {
        _selectedImage = imageFile;
      });
      await uploadImage(imageFile);
    }
  }
  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir depuis la galerie'),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Prendre une photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> uploadImage(File imageFile) async {
    final uri = Uri.parse("$baseUrl/auth/users/$userId/avatar");
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(responseBody);
        final uploadedUrl = data["avatar_url"]?.toString();

        if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("avatarUrl", uploadedUrl);
          setState(() {
            avatarUrl = uploadedUrl;
          });
          print("**********************Image uploaded: $uploadedUrl");
        }
      } catch (e) {
        print("Erreur de parsing JSON : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Réponse serveur invalide.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'envoi de l'image.")),
      );
    }
  }
  Future<void> fetchAvatarUrlFromApi() async {
    if (userId == null || userId!.isEmpty) return;
    final uri = Uri.parse("$baseUrl/auth/users/$userId/avatar");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final apiAvatarUrl = data["avatar_url"]?.toString();
        if (apiAvatarUrl != null && apiAvatarUrl.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("avatarUrl", apiAvatarUrl);
          setState(() {
            avatarUrl = apiAvatarUrl;
          });
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'avatar : $e");
    }
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    final double avatarSize = 84;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Mon profil",
          style: TextStyle(
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
          children: [
            GestureDetector(
              onTap: pickImage,
              child: GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: avatarSize / 2,
                  backgroundColor: Colors.indigo.shade100,
                  child: ClipOval(
                    child: SizedBox(
                      width: avatarSize,
                      height: avatarSize,
                      child: _selectedImage != null
                          ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      )
                          : (avatarUrl != null
                          ? Image.network(
                        avatarUrl!,
                        width: avatarSize,
                        height: avatarSize,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B3F9F),
                              ),
                            ),
                          );
                        },
                      )
                          : Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B3F9F),
                          ),
                        ),
                      )),
                    ),
                  ),
                ),
              ),

            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B3F9F),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Se déconnecter", style: TextStyle(color: Colors.red)),
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}
