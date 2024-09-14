import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _UserRegistrationFormState createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _role = '';

  final List<String> _roles = ['student', 'teacher', 'parent', 'coordinator'];
  int _currentStep = 1; // Étape actuelle : 1 pour le premier formulaire, 2 pour le second

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_currentStep == 1) {
        // Passer à l'étape 2 (second formulaire)
        setState(() {
          _currentStep = 2;
        });
      } else {
        // Hacher le mot de passe et enregistrer dans la base de données
        String hashedPassword = _hashPassword(_password);

        DatabaseHelper dbHelper = DatabaseHelper();

        await dbHelper.insertUser(
          _role,
          _name,
          _email,
          hashedPassword,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur enregistré avec succès!')),
        );

        // Réinitialiser le formulaire après l'enregistrement
        setState(() {
          _currentStep = 1;
          _name = '';
          _email = '';
          _password = '';
          _role = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer un Utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentStep == 1 ? _buildFirstForm() : _buildSecondForm(),
      ),
    );
  }

  Widget _buildFirstForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le nom';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer l\'email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Veuillez entrer un email valide';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le mot de passe';
              }
              if (value.length < 16) {
                return 'Le mot de passe doit contenir au moins 16 caractères';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez confirmer le mot de passe';
              }
              if (value != _password) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
            onSaved: (value) {},
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Rôle'),
            value: _role.isNotEmpty ? _role : null,
            items: _roles.map((String role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _role = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez sélectionner un rôle';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Suivant'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondForm() {
    return Column(
      children: <Widget>[
        const Text('Confirmez les informations suivantes :'),
        Text('Nom: $_name'),
        Text('Email: $_email'),
        Text('Rôle: $_role'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Confirmer'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStep = 1;
            });
          },
          child: const Text('Retour'),
        ),
      ],
    );
  }
}