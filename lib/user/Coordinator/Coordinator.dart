import 'package:flutter/material.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';


class CoordinatorPage extends StatelessWidget {
  const CoordinatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page coordinateur'),
      ),
      drawer: const Coordinatordrawer(),
      body: const Center(
        child: Text('Bienvenue sur la page du coordinateur'),
      ),
    );
  }
}