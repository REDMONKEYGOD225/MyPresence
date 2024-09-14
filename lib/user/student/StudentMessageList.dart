import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/StudentDrawer.dart';


class StudentMessageList extends StatelessWidget {
  const StudentMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages reçus'),
      ),
      drawer: const StudentDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('M. Dupont'),
            subtitle: const Text('Mathématiques - Devoirs à rendre'),
            trailing: const Text('12:30'),
            onTap: () {
              // Action lors du clic sur le message
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mme Martin'),
            subtitle: const Text('Physique - Changements d\'horaire'),
            trailing: const Text('14:45'),
            onTap: () {
              // Action lors du clic sur le message
            },
          ),
          // Ajoutez d'autres messages ici
        ],
      ),
    );
  }
}