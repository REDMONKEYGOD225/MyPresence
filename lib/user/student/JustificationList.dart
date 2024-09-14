import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';


class JustificationList extends StatefulWidget {
  const JustificationList({super.key});

  @override
  _JustificationListState createState() => _JustificationListState();
}

class _JustificationListState extends State<JustificationList> {
  List<Map<String, dynamic>> justifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJustifications();
  }

  Future<void> fetchJustifications() async {
    // Récupérer les justifications depuis la base de données
    var dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> data = await dbHelper.getJustifications();

    setState(() {
      justifications = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Justifications'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Raison')),
                ],
                rows: justifications.map((justification) {
                  return DataRow(cells: [
                    DataCell(Text(justification['date'] ?? '')),
                    DataCell(Text(justification['reason'] ?? '')),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}
