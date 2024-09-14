import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/auth/UserRole.dart';
import 'package:my_presence/components/drawers/CoordinatorDrawer.dart';
import 'package:my_presence/components/drawers/ParentDrawer.dart';
import 'package:my_presence/components/drawers/StudentDrawer.dart';
import 'package:my_presence/components/drawers/TeacherDrawer.dart';
import 'package:sqflite/sqflite.dart';

// Fonction pour obtenir le Drawer en fonction du rôle
Widget getDrawerForRole(String role) {
  switch (role) {
    case UserRole.student:
      return const StudentDrawer();
    case UserRole.parent:
      return const ParentDrawer();
    case UserRole.teacher:
      return const TeacherDrawer();
    case UserRole.coordinator: 
      return const Coordinatordrawer();
    default:
      throw Exception('Invalid user role: $role');
  }
}

// Fonction pour récupérer le rôle d'un utilisateur depuis la base de données
Future<String?> loginUser(String email, String password) async {
  Database db = await DatabaseHelper.initializeDatabase();

  final result = await db.rawQuery(
    'SELECT role FROM users WHERE email = ? AND password = ?',
    [email, password],
  );

  if (result.isNotEmpty) {
    return result.first['role'] as String;
  } else {
    return null; // Identifiants incorrects
  }
}