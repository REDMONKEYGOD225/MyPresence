import 'package:flutter/material.dart';
import 'package:my_presence/Connexion.dart';
import 'package:my_presence/Register.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await DatabaseHelper.initializeDatabase();

  // Vérifier si l'utilisateur est déjà enregistré
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isRegistered = prefs.getBool('is_registered') ?? false;

  runApp(MyApp(isRegistered: isRegistered));
}

class MyApp extends StatelessWidget {
  final bool isRegistered;

  const MyApp({super.key, required this.isRegistered});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isRegistered ? const Connexion() : const Register(),
    );
  }
}