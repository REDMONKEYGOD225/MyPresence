import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/ParentDrawer.dart';

class ParentPage extends StatelessWidget {
  const ParentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Parent'),
      ),
      drawer: const ParentDrawer(),
      body: const Center(
        child: Text('Bienvenue sur la page du parent'),
      ),
    );
  }
}