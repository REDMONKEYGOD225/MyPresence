import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/components/drawers/TeacherDrawer.dart';

class TeacherStudentList extends StatefulWidget {
  final int teacherId;

  const TeacherStudentList({super.key, required this.teacherId});

  @override
  _TeacherStudentListState createState() => _TeacherStudentListState();
}

class _TeacherStudentListState extends State<TeacherStudentList> {
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final students = await DatabaseHelper().getStudentsByTeacher(widget.teacherId);
    setState(() {
      _students = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Étudiants'),
      ),
      drawer: const TeacherDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Photo')),
            DataColumn(label: Text('Nom-Prénom')),
            DataColumn(label: Text('État de Présence')),
          ],
          rows: _students.map((student) {
            return DataRow(cells: [
              const DataCell(CircleAvatar(
                backgroundImage: AssetImage('assets/images/student1.png'),
              )),
              DataCell(Text('${student['name']} ${student['email']}')),
              const DataCell(PresenceDropdown()),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

class PresenceDropdown extends StatefulWidget {
  const PresenceDropdown({super.key});

  @override
  _PresenceDropdownState createState() => _PresenceDropdownState();
}

class _PresenceDropdownState extends State<PresenceDropdown> {
  String _presenceState = 'Présent';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _presenceState,
      onChanged: (String? newValue) {
        setState(() {
          _presenceState = newValue!;
        });
      },
      items: <String>['Présent', 'Absent', 'En retard']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}