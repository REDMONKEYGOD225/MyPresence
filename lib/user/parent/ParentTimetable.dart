import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/ParentDrawer.dart';


class ParentTimetable extends StatelessWidget {
  const ParentTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emploi du Temps'),
      ),
      drawer: const ParentDrawer(),
      body: Column(
        children: [
          const Text(
            'Emploi du Temps de l\'Enfant 1',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Heures')),
              DataColumn(label: Text('Lundi')),
              DataColumn(label: Text('Mardi')),
              DataColumn(label: Text('Mercredi')),
              DataColumn(label: Text('Jeudi')),
              DataColumn(label: Text('Vendredi')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('9h00 - 12h00')),
                DataCell(Text('Mathématiques (M. Lefèvre)')),
                DataCell(Text('Anglais (Mme. Dubois)')),
                DataCell(Text('Histoire (M. Dupont)')),
                DataCell(Text('Physique (M. Bernard)')),
                DataCell(Text('Informatique (Mme. Martin)')),
              ]),
              DataRow(cells: [
                DataCell(Text('14h00 - 17h00')),
                DataCell(Text('Workshop A')),
                DataCell(Text('Workshop B')),
                DataCell(Text('Cours C')),
                DataCell(Text('Cours D')),
                DataCell(Text('Cours E')),
              ]),
              // Ajoutez d'autres lignes ici...
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Emploi du Temps de l\'Enfant 2',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Heures')),
              DataColumn(label: Text('Lundi')),
              DataColumn(label: Text('Mardi')),
              DataColumn(label: Text('Mercredi')),
              DataColumn(label: Text('Jeudi')),
              DataColumn(label: Text('Vendredi')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('9h00 - 12h00')),
                DataCell(Text('Science (Mme. Laurent)')),
                DataCell(Text('Français (M. Thomas)')),
                DataCell(Text('Géographie (Mme. Dubois)')),
                DataCell(Text('Arts (M. Lefèvre)')),
                DataCell(Text('Musique (Mme. Bernard)')),
              ]),
              DataRow(cells: [
                DataCell(Text('14h00 - 17h00')),
                DataCell(Text('Workshop F')),
                DataCell(Text('Cours G')),
                DataCell(Text('Cours H')),
                DataCell(Text('Workshop I')),
                DataCell(Text('Cours J')),
              ]),
              // Ajoutez d'autres lignes ici...
            ],
          ),
        ],
      ),
    );
  }
}