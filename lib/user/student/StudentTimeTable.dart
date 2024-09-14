import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/components/drawers/StudentDrawer.dart';


class StudentTimetable extends StatefulWidget {
  const StudentTimetable({super.key});

  @override
  _StudentTimetableState createState() => _StudentTimetableState();
}

class _StudentTimetableState extends State<StudentTimetable> {
  Map<String, Map<String, String>> timetable = {};

  @override
  void initState() {
    super.initState();
    loadTimetable();
  }

  Future<void> loadTimetable() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> courseTimes = await dbHelper.getCourseTimes();

    if (courseTimes.isNotEmpty) {
      Map<String, Map<String, String>> tempTimetable = {
        '9h00-12h00': {
          'Lundi': '',
          'Mardi': '',
          'Mercredi': '',
          'Jeudi': '',
          'Vendredi': ''
        },
        '14h00-17h00': {
          'Lundi': '',
          'Mardi': '',
          'Mercredi': '',
          'Jeudi': '',
          'Vendredi': ''
        },
      };

      // Remplir le tableau avec les données du dernier emploi du temps
      for (var courseTime in courseTimes) {
        String day = _getDayOfWeek(courseTime['date']);
        String timeSlot = _getTimeSlot(courseTime['start_time']);

        if (tempTimetable[timeSlot] != null && day.isNotEmpty) {
          tempTimetable[timeSlot]![day] = courseTime['course_name'];
        }
      }

      setState(() {
        timetable = tempTimetable;
      });
    }
  }

  String _getDayOfWeek(String date) {
    DateTime dateTime = DateTime.parse(date);
    switch (dateTime.weekday) {
      case DateTime.monday:
        return 'Lundi';
      case DateTime.tuesday:
        return 'Mardi';
      case DateTime.wednesday:
        return 'Mercredi';
      case DateTime.thursday:
        return 'Jeudi';
      case DateTime.friday:
        return 'Vendredi';
      default:
        return '';
    }
  }

  String _getTimeSlot(String startTime) {
    if (startTime == '09:00:00') {
      return '9h00-12h00';
    } else if (startTime == '14:00:00') {
      return '14h00-17h00';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emploi du temps'),
      ),
      drawer: const StudentDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20.0,
          columns: const [
            DataColumn(
              label: Text(
                'Heure',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Lundi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Mardi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Mercredi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Jeudi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Vendredi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('9h00-12h00')),
              DataCell(Text(timetable['9h00-12h00']?['Lundi'] ?? '')),
              DataCell(Text(timetable['9h00-12h00']?['Mardi'] ?? '')),
              DataCell(Text(timetable['9h00-12h00']?['Mercredi'] ?? '')),
              DataCell(Text(timetable['9h00-12h00']?['Jeudi'] ?? '')),
              DataCell(Text(timetable['9h00-12h00']?['Vendredi'] ?? '')),
            ]),
            DataRow(cells: [
              const DataCell(Text('14h00-17h00')),
              DataCell(Text(timetable['14h00-17h00']?['Lundi'] ?? '')),
              DataCell(Text(timetable['14h00-17h00']?['Mardi'] ?? '')),
              DataCell(Text(timetable['14h00-17h00']?['Mercredi'] ?? '')),
              DataCell(Text(timetable['14h00-17h00']?['Jeudi'] ?? '')),
              DataCell(Text(timetable['14h00-17h00']?['Vendredi'] ?? '')),
            ]),
          ],
        ),
      ),
    );
  }
}