import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';

class ParentForm extends StatefulWidget {
  final Map<String, dynamic>? parent;

  const ParentForm({super.key, this.parent});

  @override
  _ParentFormState createState() => _ParentFormState();
}

class _ParentFormState extends State<ParentForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _studentController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.parent != null) {
      _nameController.text = widget.parent!['name'];
      _emailController.text = widget.parent!['email'];
      _studentController.text = widget.parent!['student'];
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter/Modifier un Parent'),
      ),
      drawer: const Coordinatordrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom du Parent'),
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
              controller: _studentController,
              decoration: const InputDecoration(labelText: 'Étudiant associé'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                String student = _studentController.text;

                String hashedPassword = _hashPassword(password);

                if (widget.parent == null) {
                  await _databaseHelper.insertParent(name, email, hashedPassword, student);
                } else {
                  await _databaseHelper.updateParent(
                    widget.parent!['id'],
                    name,
                    email,
                    hashedPassword,
                    student,
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