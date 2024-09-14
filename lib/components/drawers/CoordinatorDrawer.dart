import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/user/Coordinator/CoordinatorAttendanceChart.dart';

import 'package:my_presence/user/Coordinator/CoordinatorForm.dart';
import 'package:my_presence/user/Coordinator/CoordinatorList.dart';
import 'package:my_presence/user/Coordinator/MessageList.dart';
import 'package:my_presence/user/Coordinator/ParentForm.dart';
import 'package:my_presence/user/Coordinator/ParentList.dart';
import 'package:my_presence/user/Coordinator/Profile.dart';
import 'package:my_presence/user/Coordinator/StudentForm.dart';
import 'package:my_presence/user/Coordinator/StudentList.dart';
import 'package:my_presence/user/Coordinator/TeacherForm.dart';
import 'package:my_presence/user/Coordinator/TeacherList.dart';
import 'package:my_presence/user/Coordinator/TimeTableForm.dart';
import 'package:my_presence/user/Coordinator/TimeTableList.dart';
import 'package:my_presence/user/student/JustificationList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Coordinatordrawer extends StatelessWidget {
  const Coordinatordrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu Coordinateur'),
          ),
          ExpansionTile(
            leading: const Icon(FontAwesome5Solid.graduation_cap),
            title: const Text('Étudiants'),
            children: <Widget>[
              ListTile(
                leading: const Icon(FontAwesome5Solid.users),
                title: const Text('Liste des Étudiants'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentList(coordinatorId: 1),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(FontAwesome5Solid.user_plus),
                title: const Text('Ajouter un Étudiant'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentForm(studentId: null),
                    ),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(FontAwesome5Solid.users),
            title: const Text('Parents'),
            children: <Widget>[
              ListTile(
                leading: const Icon(FontAwesome5Solid.users),
                title: const Text('Liste des Parents'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ParentList(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(FontAwesome5Solid.user_plus),
                title: const Text('Ajouter un Parent'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ParentForm(),
                    ),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(FontAwesome5Solid.chalkboard_teacher),
            title: const Text('Enseignants'),
            children: <Widget>[
              ListTile(
                leading: const Icon(FontAwesome5Solid.users),
                title: const Text('Liste des Enseignants'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherList(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(FontAwesome5Solid.user_plus),
                title: const Text('Ajouter un Enseignant'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherForm(),
                    ),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(FontAwesome5Solid.user_cog),
            title: const Text('Coordinateurs'),
            children: <Widget>[
              ListTile(
                leading: const Icon(FontAwesome5Solid.users),
                title: const Text('Liste des Coordinateurs'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CoordinatorList(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(FontAwesome5Solid.user_plus),
                title: const Text('Ajouter un Coordinateur'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CoordinatorForm(),
                    ),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(FontAwesome5Solid.calendar),
            title: const Text('Emplois du Temps'),
            children: <Widget>[
              ListTile(
                leading: const Icon(FontAwesome5Solid.list),
                title: const Text('Liste des Emplois du Temps'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TimeTableList(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(FontAwesome5Solid.calendar_plus),
                title: const Text('Ajouter un Emploi du Temps'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TimeTableForm(),
                    ),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(FontAwesome5Solid.user),
            title: const Text('Profil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CoordinatorProfile(),
                ),
              );
            },
          ),
           ListTile(
            leading: const Icon(FontAwesome5Solid.envelope),
            title: const Text('liste des justififications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JustificationList(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5Solid.envelope),
            title: const Text('taux de presence etudiant'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoordinatorAttendanceChart(studentAttendances: const [],),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5Solid.envelope),
            title: const Text('Messages'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessageList(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5Solid.sign_out_alt),
            title: const Text('Déconnexion'),
            onTap: () {
              _logoutUser(context);
            },
          ),
        ],
      ),
    );
  }

  void _logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    String? role = prefs.getString('role');

    if (userId != null && role != null) {
      final databaseHelper = DatabaseHelper();
      await databaseHelper.logoutUser(userId, role, context);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}