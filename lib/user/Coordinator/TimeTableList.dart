import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/user/Coordinator/TimeTableForm.dart';

class TimeTableList extends StatefulWidget {
  const TimeTableList({super.key});

  @override
  _TimeTableListState createState() => _TimeTableListState();
}

class _TimeTableListState extends State<TimeTableList> {
  List<Map<String, dynamic>> _courseTimes = [];

  @override
  void initState() {
    super.initState();
    _loadCourseTimes();
  }

  Future<void> _loadCourseTimes() async {
    final data = await DatabaseHelper.instance.getCourseTimes();
    setState(() {
      _courseTimes = data;
    });
  }

  void _navigateToForm(BuildContext context, {Map<String, dynamic>? courseTime}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeTableForm(courseTime: courseTime), // Passer courseTime si existant
      ),
    ).then((_) {
      _loadCourseTimes(); // Recharger après retour du formulaire
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des emplois du temps'),
      ),
      body: _courseTimes.isEmpty
          ? const Center(child: Text('Aucun emploi du temps disponible'))
          : DataTable(
              columns: const [
                DataColumn(label: Text('Jour')),
                DataColumn(label: Text('Heure')),
                DataColumn(label: Text('ID Classe')),
                DataColumn(label: Text('ID Professeur')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _courseTimes.map((courseTime) {
                return DataRow(cells: [
                  DataCell(Text(courseTime['date'])),
                  DataCell(Text('${courseTime['start_time']} - ${courseTime['end_time']}')),
                  DataCell(Text('${courseTime['class_id']}')),
                  DataCell(Text('${courseTime['teacher_id']}')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToForm(context, courseTime: courseTime),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}