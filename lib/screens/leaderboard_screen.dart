import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedCriterion = 'points';

  final List<Map<String, dynamic>> users = [
    {
      'name': 'Alice',
      'points': 1023,
      'questions': 210,
      'streak': 15,
    },
    {
      'name': 'Bob',
      'points': 980,
      'questions': 225,
      'streak': 10,
    },
    {
      'name': 'Charlie',
      'points': 1112,
      'questions': 198,
      'streak': 21,
    },
    {
      'name': 'Diane',
      'points': 950,
      'questions': 180,
      'streak': 5,
    },
  ];

  List<Map<String, dynamic>> get sortedUsers {
    switch (selectedCriterion) {
      case 'questions':
        return [...users]..sort((a, b) => b['questions'].compareTo(a['questions']));
      case 'streak':
        return [...users]..sort((a, b) => b['streak'].compareTo(a['streak']));
      case 'points':
      default:
        return [...users]..sort((a, b) => b['points'].compareTo(a['points']));
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
          'Classement',
          style: TextStyle(
            color: Color(0xFF3B3F9F),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF3B3F9F)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedCriterion,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              iconEnabledColor: Color(0xFF3B3F9F),
              style: const TextStyle(color: Color(0xFF3B3F9F), fontSize: 16),
              underline: Container(
                height: 2,
                color: Color(0xFF3B3F9F),
              ),
              items: const [
                DropdownMenuItem(value: 'points', child: Text('Par points')),
                DropdownMenuItem(value: 'questions', child: Text('Par questions répondues')),
                DropdownMenuItem(value: 'streak', child: Text('Par série de jours')),
              ],
              onChanged: (value) => setState(() => selectedCriterion = value!),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: sortedUsers.length,
                itemBuilder: (context, index) {
                  final user = sortedUsers[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: Text(
                          user['name'][0].toUpperCase(),
                          style: const TextStyle(color: Color(0xFF3B3F9F), fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        selectedCriterion == 'points'
                            ? '${user['points']} pts'
                            : selectedCriterion == 'questions'
                            ? '${user['questions']} questions'
                            : '${user['streak']} jours consécutifs',
                      ),
                      trailing: Text('#${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
