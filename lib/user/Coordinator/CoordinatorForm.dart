import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';

class CoordinatorForm extends StatefulWidget {
  final Map<String, dynamic>? coordinator;

  const CoordinatorForm({super.key, this.coordinator});

  @override
  _CoordinatorFormState createState() => _CoordinatorFormState();
}

class _CoordinatorFormState extends State<CoordinatorForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _classController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.coordinator != null) {
      _nameController.text = widget.coordinator!['name'];
      _emailController.text = widget.coordinator!['email'];
      _classController.text = widget.coordinator!['class'];
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // Convertir le mot de passe en bytes
    final digest = sha256.convert(bytes); // Hasher avec SHA-256
    return digest.toString(); // Retourner le hash en format hexadécimal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter/Modifier un Coordinateur'),
      ),
      drawer: const Coordinatordrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom du Coordinateur'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            TextField(
              controller: _classController,
              decoration: const InputDecoration(labelText: 'Classe associée'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                String className = _classController.text;

                String hashedPassword = _hashPassword(password); // Hashage du mot de passe

                if (widget.coordinator == null) {
                  // Ajouter un nouveau coordinateur
                  await _databaseHelper.insertCoordinator(name as int, email, hashedPassword, className);
                } else {
                  // Mettre à jour le coordinateur existant
                  await _databaseHelper.updateCoordinator(
                    widget.coordinator!['id'],
                    name as int,
                    email,
                    hashedPassword,
                    className,
                  );
                }

                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
