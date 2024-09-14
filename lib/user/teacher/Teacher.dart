import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/TeacherDrawer.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Enseignant'),
      ),
      drawer: const TeacherDrawer(),
      body: const Center(
        child: Text('Bienvenue sur la page de l\'enseignant'),
      ),
    );
  }
}