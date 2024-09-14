import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';




class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Messages'),
      ),
      drawer: const Coordinatordrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Expéditeur')),
            DataColumn(label: Text('Destinataire')),
            DataColumn(label: Text('Message')),
            DataColumn(label: Text('Date')),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('Admin')),
              DataCell(Text('Tous les étudiants')),
              DataCell(Text('Rappel pour la réunion de demain')),
              DataCell(Text('24/08/2024')),
            ]),
            DataRow(cells: [
              DataCell(Text('Professeur')),
              DataCell(Text('Classe 10A')),
              DataCell(Text('Devoir à rendre lundi')),
              DataCell(Text('23/08/2024')),
            ]),
            // Autres lignes...
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Envoyer un Message'),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Destinataire'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Message'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Ajouter la logique pour envoyer le message ici
                      Navigator.of(context).pop();
                    },
                    child: const Text('Envoyer'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}