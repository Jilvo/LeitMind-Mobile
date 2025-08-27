import 'package:flutter/material.dart';
import '../services/subscription_service.dart';

class SubscribeThemesScreen extends StatefulWidget {
  const SubscribeThemesScreen({super.key});

  @override
  State<SubscribeThemesScreen> createState() => _SubscribeThemesScreenState();
}

class _SubscribeThemesScreenState extends State<SubscribeThemesScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  List<Map<String, dynamic>> themes = [];
  Set<String> subscribed = {};
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  // Mapping des icônes par nom de catégorie
  IconData _getIconForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'histoire':
        return Icons.history_edu_outlined;
      case 'géographie':
        return Icons.public_outlined;
      case 'culture':
        return Icons.palette_outlined;
      case 'géopolitique':
        return Icons.language_outlined;
      case 'science':
        return Icons.science_outlined;
      case 'sport':
        return Icons.sports_soccer_outlined;
      case 'technologie':
        return Icons.computer_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Future<void> _loadSubscriptions() async {
    try {
      print('🔄 Chargement des abonnements...');
      final subscriptions = await _subscriptionService.getUserSubscriptions();
      print('📋 Abonnements reçus: $subscriptions');
      
      setState(() {
        themes = subscriptions.map((sub) => {
          'category_id': sub['category_id'],
          'name': sub['category_name'],
          'description': sub['description'] ?? 'Explorez cette catégorie passionnante.',
          'icon': _getIconForCategory(sub['category_name']),
        }).toList();
        
        // Debug: montrer tous les abonnements avant filtrage
        print('🔍 Tous les abonnements:');
        for (var sub in subscriptions) {
          print('   - ${sub['category_name']}: subscribed = ${sub['subscribed']}');
        }
        
        subscribed = subscriptions
            .where((sub) => sub['subscribed'] == true)
            .map((sub) => sub['category_name'] as String)
            .toSet();
        
        print('✅ Catégories finalement marquées comme abonnées: $subscribed');
        isLoading = false;
      });
    } catch (e) {
      print('💥 Erreur lors du chargement: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors du chargement des catégories")),
        );
      }
    }
  }

  void toggleSubscription(String theme) {
    setState(() {
      if (subscribed.contains(theme)) {
        subscribed.remove(theme);
      } else {
        subscribed.add(theme);
      }
    });
  }

  Future<void> submitPreferences() async {
    print('🔄 Début de submitPreferences');
    setState(() => isSaving = true);

    try {
      print('📝 Themes disponibles: ${themes.length}');
      print('🔍 Détail des themes: $themes');
      print('✅ Catégories sélectionnées: $subscribed');
      
      // Debug: vérifier le contenu des themes avant filtrage
      for (var theme in themes) {
        final themeName = theme['name'];
        final isSelected = subscribed.contains(themeName);
        print('🎯 Theme: "$themeName" - Selected: $isSelected');
      }
      
      // Préparer les données au format attendu par l'API
      // Envoyer TOUTES les catégories avec leur état (true/false)
      final subscriptions = themes
          .map((theme) => {
            'category_id': theme['category_id'],
            'subscribed': subscribed.contains(theme['name']),
          }).toList();

      print('📤 Données à envoyer: $subscriptions');
      print('📊 Nombre de subscriptions: ${subscriptions.length}');
      print('🌐 Appel du service...');
      
      final success = await _subscriptionService.updateUserSubscriptions(subscriptions);
      
      print('📋 Résultat du service: $success');

      if (mounted) {
        if (success) {
          print('✅ Succès - Affichage du message de succès');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Préférences enregistrées")),
          );
        } else {
          print('❌ Échec - Affichage du message d\'erreur');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur lors de l'enregistrement")),
          );
        }
      }
    } catch (e) {
      print('💥 Exception capturée: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'enregistrement")),
        );
      }
    } finally {
      print('🏁 Fin de submitPreferences - isSaving = false');
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "S'abonner aux thèmes",
          style: TextStyle(
            color: Color(0xFF3B3F9F),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF3B3F9F)),
        actions: [
          isSaving
              ? const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
              : TextButton(
            onPressed: isLoading ? null : submitPreferences,
            child: const Text(
              "Valider",
              style: TextStyle(
                color: Color(0xFF3B3F9F),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : themes.isEmpty
              ? const Center(
                  child: Text(
                    'Aucune catégorie disponible',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          final isSubscribed = subscribed.contains(theme['name']);

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(theme['icon'], size: 32, color: Color(0xFF3B3F9F)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          theme['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Switch(
                        value: isSubscribed,
                        onChanged: isLoading || isSaving 
                            ? null 
                            : (_) => toggleSubscription(theme['name'] as String),
                        activeColor: const Color(0xFF3B3F9F),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    theme['description'],
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
