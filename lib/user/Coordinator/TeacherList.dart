import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';
import 'package:my_presence/user/Coordinator/TeacherForm.dart';


class TeacherList extends StatefulWidget {
  const TeacherList({super.key});

  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  List<Map<String, dynamic>> teachers = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  // Charger les enseignants depuis la base de données
  Future<void> _loadTeachers() async {
    List<Map<String, dynamic>> result = await _databaseHelper.getTeachers();
    setState(() {
      teachers = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Enseignants'),
      ),
      drawer: const Coordinatordrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nom')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Mot de passe')),
            DataColumn(label: Text('Filière')),
            DataColumn(label: Text('Actions')),
          ],
          rows: teachers.map((teacher) {
            return DataRow(
              cells: [
                DataCell(Text(teacher['name'])),
                DataCell(Text(teacher['email'])),
                const DataCell(Text('********')),
                DataCell(Text(teacher['subject'])),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherForm(
                                teacher: teacher, // Passer l'enseignant pour l'édition
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _databaseHelper.deleteTeacher(teacher['id']);
                          _loadTeachers();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TeacherForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}