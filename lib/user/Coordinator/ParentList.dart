import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';
import 'package:my_presence/user/Coordinator/ParentForm.dart';

class ParentList extends StatefulWidget {
  const ParentList({super.key});

  @override
  _ParentListState createState() => _ParentListState();
}

class _ParentListState extends State<ParentList> {
  List<Map<String, dynamic>> parents = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadParents();
  }

  // Charger les parents depuis la base de données
  Future<void> _loadParents() async {
    List<Map<String, dynamic>> result = await _databaseHelper.getParents();
    setState(() {
      parents = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Parents'),
      ),
      drawer: const Coordinatordrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nom')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Mot de passe')),
            DataColumn(label: Text('Étudiant')),
            DataColumn(label: Text('Actions')), // Colonne pour les boutons Update/Delete
          ],
          rows: parents.map((parent) {
            return DataRow(
              cells: [
                DataCell(Text(parent['name'])),
                DataCell(Text(parent['email'])),
                const DataCell(Text('********')),
                DataCell(Text(parent['student'])),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ParentForm(
                                parent: parent, // Passer le parent pour l'édition
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _databaseHelper.deleteParent(parent['id']);
                          _loadParents();
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
            MaterialPageRoute(builder: (context) => const ParentForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}