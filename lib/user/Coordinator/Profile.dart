import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';



class CoordinatorProfile extends StatelessWidget {
  const CoordinatorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Administrateur'),
      ),
      drawer: const Coordinatordrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom : Admin User',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Email : admin@example.com',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Rôle : Administrateur',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action pour modifier le profil
              },
              child: const Text('Modifier le profil'),
            ),
          ],
        ),
      ),
    );
  }
}