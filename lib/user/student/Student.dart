import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/StudentDrawer.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Étudiant'),
      ),
      drawer: const StudentDrawer(),
      body: const Center(
        child: Text('Bienvenue sur la page de l\'étudiant'),
      ),
    );
  }
}
