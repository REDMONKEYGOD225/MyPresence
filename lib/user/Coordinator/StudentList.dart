import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/components/PresenceDropdown.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';
import 'package:my_presence/user/Coordinator/StudentForm.dart';
import 'package:intl/intl.dart';

class StudentList extends StatefulWidget {
  final int coordinatorId; // Ajouter l'ID du coordinateur en paramètre

  const StudentList({super.key, required this.coordinatorId}); // Mettre à jour le constructeur

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Map<String, dynamic>> studentRecords = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadStudents(widget.coordinatorId); // Passer l'ID du coordinateur
  }

  // Charger les étudiants associés à un coordinateur
  Future<void> _loadStudents(int coordinatorId) async {
    List<Map<String, dynamic>> result = await _databaseHelper.getStudentsByCoordinator(coordinatorId);
    setState(() {
      studentRecords = result;
    });
  }

  // Sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _loadStudents(widget.coordinatorId); // Recharger les étudiants pour la nouvelle date
      });
    }
  }

  // Fonction pour sauvegarder ou modifier l'état de présence
  Future<void> _saveOrUpdatePresence(int studentId, String presence, String? presenceDate) async {
    DateTime currentDate = DateTime.now();
    bool isFridayEveningOrLater = currentDate.weekday == DateTime.friday &&
        currentDate.hour >= 18;

    if (isFridayEveningOrLater) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Modification impossible après le vendredi soir.'),
        ),
      );
      return;
    }

    if (presenceDate == null) {
      // Insérer une nouvelle présence
      await _databaseHelper.insertstudent_presence(studentId, 0, currentDate.toString(), presence);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Présence enregistrée avec succès.'),
        ),
      );
    } else {
      DateTime initialPresenceDate = DateFormat('yyyy-MM-dd').parse(presenceDate);
      if (currentDate.difference(initialPresenceDate).inDays <= 14) {
        // Mettre à jour la présence
        // Assurez-vous de passer l'ID de la présence à mettre à jour si disponible
        await _databaseHelper.updatestudent_presence(
          0, // Remplacez ceci par l'ID de la présence à mettre à jour si disponible
          studentId,
          0, // Remplacez ceci par l'ID du cours si disponible
          currentDate.toString(),
          presence
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Présence modifiée avec succès.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modification de l\'état de présence impossible après deux semaines.'),
          ),
        );
      }
    }

    _loadStudents(widget.coordinatorId); // Recharger la liste après la mise à jour
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Étudiants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      drawer: const Coordinatordrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Photo')),
            DataColumn(label: Text('Nom-Prénom')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Classe')),
            DataColumn(label: Text('État de Présence')),
            DataColumn(label: Text('Actions')),
          ],
          rows: studentRecords.map((record) {
            return DataRow(
              cells: [
                const DataCell(CircleAvatar(
                  backgroundImage: AssetImage('assets/images/student1.png'),
                )),
                DataCell(Text('${record['name']}')),
                DataCell(Text(record['email'] ?? 'N/A')), // Gestion des valeurs nulles
                DataCell(Text(record['class'] ?? 'N/A')), // Gestion des valeurs nulles
                DataCell(PresenceDropdown(
                  initialPresence: record['presence_state'] ?? 'N/A', // Valeur par défaut si null
                  presenceDate: record['presence_date'],
                  onSave: (presence) {
                    _saveOrUpdatePresence(record['id'], presence, record['presence_date']);
                  },
                )),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentForm(studentId: record['id']),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _databaseHelper.deleteStudent(record['id']);
                          _loadStudents(widget.coordinatorId); // Rafraîchir la liste après la suppression
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
            MaterialPageRoute(builder: (context) => const StudentForm(studentId: null,)),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}