import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';
import 'package:my_presence/user/Coordinator/CoordinatorForm.dart';
import 'package:my_presence/assets/database/database_helper.dart';

class CoordinatorList extends StatefulWidget {
  const CoordinatorList({super.key});

  @override
  _CoordinatorListState createState() => _CoordinatorListState();
}

class _CoordinatorListState extends State<CoordinatorList> {
  List<Map<String, dynamic>> coordinators = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadCoordinators();
  }

  // Charger les coordinateurs depuis la base de données
  Future<void> _loadCoordinators() async {
    List<Map<String, dynamic>> result = await _databaseHelper.getCoordinators();
    setState(() {
      coordinators = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Coordinateurs'),
      ),
      drawer: const Coordinatordrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nom')),
            DataColumn(label: Text('Classe')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Mot de passe')),
            DataColumn(label: Text('Actions')),
          ],
          rows: coordinators.map((coordinator) {
            return DataRow(
              cells: [
                DataCell(Text(coordinator['name'])),
                DataCell(Text(coordinator['class'])),
                DataCell(Text(coordinator['email'])),
                const DataCell(Text('********')),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CoordinatorForm(
                                coordinator: coordinator, // Passer le coordinateur pour l'édition
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          // Appel de la méthode pour supprimer un coordinateur
                          await _databaseHelper.deleteCoordinator(coordinator['id']);
                          // Rafraîchir la liste après la suppression
                          _loadCoordinators();
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
            MaterialPageRoute(builder: (context) => const CoordinatorForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}