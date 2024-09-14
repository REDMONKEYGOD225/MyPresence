import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:crypto/crypto.dart';  
import 'dart:convert';
import 'package:my_presence/auth/UserRole.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/user/coordinator/Coordinator.dart';
import 'package:my_presence/user/parent/Parent.dart';
import 'package:my_presence/user/student/Student.dart';
import 'package:my_presence/user/teacher/Teacher.dart';

class Connexion extends StatelessWidget {
  const Connexion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A90E2), Color(0xFF50A7C2)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 10.0,
                shadowColor: Colors.black38,
                child: const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: LoginForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  // Fonction pour récupérer l'utilisateur de la base de données
  Future<Map<String, dynamic>?> _getUserFromDatabase(String email) async {
    final db = await DatabaseHelper.initializeDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      'users', // Assurez-vous que votre table s'appelle bien 'users'
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Fonction pour hacher le mot de passe
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // convertir en bytes
    var digest = sha256.convert(bytes); // hachage SHA-256
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            MaterialCommunityIcons.account_circle,
            size: 80,
            color: Colors.blueGrey[800],
          ),
          const SizedBox(height: 30.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Colors.blueGrey),
              filled: true,
              fillColor: Colors.blueGrey.withOpacity(0.1),
              prefixIcon: const Icon(Icons.email, color: Colors.blueGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre email';
              }
              return null;
            },
            onSaved: (value) {
              _email = value;
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              labelStyle: const TextStyle(color: Colors.blueGrey),
              filled: true,
              fillColor: Colors.blueGrey.withOpacity(0.1),
              prefixIcon: const Icon(Icons.lock, color: Colors.blueGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre mot de passe';
              }
              return null;
            },
            onSaved: (value) {
              _password = value;
            },
          ),
          const SizedBox(height: 40.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              backgroundColor: const Color(0xFF50A7C2),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Récupérer les informations de l'utilisateur à partir de la base de données
                final user = await _getUserFromDatabase(_email!);

                if (user != null) {
                  String hashedPassword = _hashPassword(_password!);
                  
                  // Comparer le mot de passe haché avec celui de la base de données
                  if (user['password'] == hashedPassword) {
                    String role = user['role'];
                    Widget destinationPage;

                    switch (role) {
                      case UserRole.student:
                        destinationPage = const StudentPage();
                        break;
                      case UserRole.parent:
                        destinationPage = const ParentPage();
                        break;
                      case UserRole.teacher:
                        destinationPage = const TeacherPage();
                        break;
                      case UserRole.coordinator:
                        destinationPage = const CoordinatorPage();
                        break;
                      default:
                        destinationPage = const Center(child: Text('Page non trouvée'));
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => destinationPage),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Mot de passe incorrect')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Utilisateur non trouvé')),
                  );
                }
              }
            },
            child: const Text(
              'Se connecter',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}