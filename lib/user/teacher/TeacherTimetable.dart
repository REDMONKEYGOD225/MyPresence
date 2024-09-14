import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/TeacherDrawer.dart';


class TeacherTimetable extends StatelessWidget {
  const TeacherTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emploi du temps'),
      ),
      drawer: const TeacherDrawer(), 
      body: Center(
        child: DataTable(
          columnSpacing: 20.0, 
          columns: const [
            DataColumn(
              label: Text(
                'Classe',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Date',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Heures',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Cours',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Professeur',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('Classe A')),
              DataCell(Text('Lundi, 26-août-2024')),
              DataCell(Text('9h00-12h00')),
              DataCell(Text('Mathématiques')),
              DataCell(Text('Prof. Dupont')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classe B')),
              DataCell(Text('Lundi, 26-août-2024')),
              DataCell(Text('14h00-17h00')),
              DataCell(Text('Physique')),
              DataCell(Text('Prof. Dupont')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classe A')),
              DataCell(Text('Mardi, 27-août-2024')),
              DataCell(Text('9h00-12h00')),
              DataCell(Text('Chimie')),
              DataCell(Text('Prof. Dupont')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classe B')),
              DataCell(Text('Mardi, 27-août-2024')),
              DataCell(Text('14h00-17h00')),
              DataCell(Text('Biologie')),
              DataCell(Text('Prof. Dupont')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classe A')),
              DataCell(Text('Mercredi, 28-août-2024')),
              DataCell(Text('9h00-12h00')),
              DataCell(Text('Histoire')),
              DataCell(Text('Prof. Dupont')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classe B')),
              DataCell(Text('Mercredi, 28-août-2024')),
              DataCell(Text('14h00-17h00')),
              DataCell(Text('Géographie')),
              DataCell(Text('Prof. Dupont')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classe A')),
              DataCell(Text('Jeudi, 29-août-2024')),
              DataCell(Text('9h00-12h00')),
              DataCell(Text('Philosophie')),
              DataCell(Text('Prof. Dupont')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classe B')),
              DataCell(Text('Jeudi, 29-août-2024')),
              DataCell(Text('14h00-17h00')),
              DataCell(Text('Anglais')),
              DataCell(Text('Prof. Dupont')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classe A')),
              DataCell(Text('Vendredi, 30-août-2024')),
              DataCell(Text('9h00-12h00')),
              DataCell(Text('Économie')),
              DataCell(Text('Prof. Dupont')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classe B')),
              DataCell(Text('Vendredi, 30-août-2024')),
              DataCell(Text('14h00-17h00')),
              DataCell(Text('Espagnol')),
              DataCell(Text('Prof. Dupont')),
            ]),
          ],
        ),
      ),
    );
  }
}
