import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/user/parent/ParentAttendanceChart.dart';
import 'package:my_presence/user/parent/ParentMessage.dart';
import 'package:my_presence/user/parent/ParentTimetable.dart';
import 'package:my_presence/user/parent/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ParentDrawer extends StatelessWidget {
  const ParentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Parent',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Emploi du temps'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParentTimetable()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParentMessage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Taux de présence de l\'étudiant'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ParentAttendanceChart(studentAttendances: const [],)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParentProfile()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Se déconnecter'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

void _logout(BuildContext context) async {
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