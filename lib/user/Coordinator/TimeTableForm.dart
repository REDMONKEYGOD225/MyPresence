import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_presence/assets/database/database_helper.dart';

class TimeTableForm extends StatefulWidget {
  final Map<String, dynamic>? courseTime; // Ajout du paramètre courseTime

  const TimeTableForm({super.key, this.courseTime});

  @override
  _TimeTableFormState createState() => _TimeTableFormState();
}

class _TimeTableFormState extends State<TimeTableForm> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  // Stocker les activités sélectionnées et les détails des cours
  Map<String, String> selectedActivities = {};
  Map<String, int> courseIds = {};
  Map<String, int> teacherIds = {};

  // Jours de la semaine
  final days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"];

  // Créneaux horaires
  final timeSlots = ["9h00-12h00", "14h00-17h00"];

  @override
  void initState() {
    super.initState();
    // Si un courseTime est passé, on initialise les valeurs dans le formulaire
    if (widget.courseTime != null) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    // Charger les valeurs du courseTime passé dans le formulaire
    String date = widget.courseTime!['date'];
    String startTime = widget.courseTime!['start_time'];
    String endTime = widget.courseTime!['end_time'];
    int courseId = widget.courseTime!['course_id'];
    int teacherId = widget.courseTime!['teacher_id'];

    String key = "$date-$startTime-$endTime";
    setState(() {
      selectedActivities[key] = "Cours"; // On suppose que c'est un "Cours"
      courseIds[key] = courseId;
      teacherIds[key] = teacherId;
    });
  }

  Widget buildTableCell(String day, String timeSlot) {
    String key = "$day-$timeSlot";

    return Column(
      children: [
        DropdownButton<String>(
          value: selectedActivities[key],
          hint: const Text('Sélectionnez une activité'),
          items: ["Cours", "E-learning", "Workshop"]
              .map((activity) => DropdownMenuItem(
                    value: activity,
                    child: Text(activity),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedActivities[key] = value!;
            });
          },
        ),
        if (selectedActivities[key] == "Cours") ...[
          TextField(
            decoration: const InputDecoration(labelText: 'ID du cours'),
            onChanged: (value) {
              setState(() {
                courseIds[key] = int.tryParse(value) ?? 0;
              });
            },
            controller: widget.courseTime != null
                ? TextEditingController(text: widget.courseTime!['course_id'].toString())
                : null,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'ID du professeur'),
            onChanged: (value) {
              setState(() {
                teacherIds[key] = int.tryParse(value) ?? 0;
              });
            },
            controller: widget.courseTime != null
                ? TextEditingController(text: widget.courseTime!['teacher_id'].toString())
                : null,
          ),
        ],
      ],
    );
  }

  Widget buildTable() {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            const TableCell(child: Center(child: Text("Heure"))),
            ...days.map((day) => TableCell(child: Center(child: Text(day)))),
          ],
        ),
        ...timeSlots.map(
          (timeSlot) => TableRow(
            children: [
              TableCell(child: Center(child: Text(timeSlot))),
              ...days.map((day) => TableCell(child: buildTableCell(day, timeSlot))),
            ],
          ),
        ),
      ],
    );
  }

  void saveTimeTable() async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    for (var day in days) {
      for (var timeSlot in timeSlots) {
        String key = "$day-$timeSlot";
        String date = dateFormat.format(_getDateForDay(day));
        String startTime = _getStartTimeForSlot(timeSlot);
        String endTime = _getEndTimeForSlot(timeSlot);

        if (selectedActivities[key] == "Cours" && courseIds[key] != null && teacherIds[key] != null) {
          await databaseHelper.insertCourseTime(
            courseIds[key]!,
            1, // Remplacez par l'ID de la classe correspondante
            teacherIds[key]!,
            date,
            startTime,
            endTime,
          );
        }
      }
    }
  }

  DateTime _getDateForDay(String day) {
    final today = DateTime.now();
    int dayIndex = days.indexOf(day);
    return today.add(Duration(days: dayIndex - today.weekday + 1));
  }

  String _getStartTimeForSlot(String timeSlot) {
    return timeSlot.split('-').first;
  }

  String _getEndTimeForSlot(String timeSlot) {
    return timeSlot.split('-').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulaire Emploi du Temps')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildTable(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveTimeTable,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}