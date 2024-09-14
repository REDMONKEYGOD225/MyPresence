import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/ParentDrawer.dart';


class ParentMessage extends StatelessWidget {
  const ParentMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      drawer: const ParentDrawer(),
      body: Column(
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text('Expéditeur')),
              DataColumn(label: Text('Titre')),
              DataColumn(label: Text('Contenu')),
              DataColumn(label: Text('Heure')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('Prof. Dupont')),
                DataCell(Text('Réunion')),
                DataCell(Text('Votre enfant doit assister à une réunion...')),
                DataCell(Text('10:00')),
              ]),
              DataRow(cells: [
                DataCell(Text('Mme. Martin')),
                DataCell(Text('Devoir')),
                DataCell(Text('Votre enfant a un devoir à rendre...')),
                DataCell(Text('14:30')),
              ]),
              // Ajoutez d'autres lignes ici...
            ],
          ),
          // Si nécessaire, ajoutez des espaces ici
        ],
      ),
    );
  }
}