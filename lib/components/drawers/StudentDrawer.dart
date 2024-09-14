import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/user/student/JustificationForm.dart';
import 'package:my_presence/user/student/Profile.dart';
import 'package:my_presence/user/student/StudentMessageList.dart';
import 'package:my_presence/user/student/StudentTimeTable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

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
            child: Text('Menu Étudiant'),
          ),
          ListTile(
            leading: const Icon(FontAwesome.university),
            title: const Text('Cours'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentTimetable()),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome.envelope),
            title: const Text('Messages'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentMessageList()),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome.envelope),
            title: const Text('Justification'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const JustificationForm(studentPresenceId: null),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome.user),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome.sign_out),
            title: const Text('Logout'),
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
