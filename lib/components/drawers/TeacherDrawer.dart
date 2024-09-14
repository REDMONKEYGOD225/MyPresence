import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:my_presence/user/teacher/Profile.dart';
import 'package:my_presence/user/teacher/TeacherAttendanceChart.dart';

import 'package:my_presence/user/teacher/TeacherStudentList.dart';
import 'package:my_presence/user/teacher/TeacherTimetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer({super.key});

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
            child: Text('Menu Enseignant'),
          ),
          ListTile(
            leading: const Icon(FontAwesome5Solid.chalkboard_teacher),
            title: const Text('Mes Classes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherStudentList(teacherId: 1),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5Solid.calendar_alt),
            title: const Text('Emploi du temps'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeacherTimetable()),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5Solid.calendar_alt),
            title: const Text('liste des justifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherAttendanceChart(studentAttendances: const [],)),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5Solid.user_cog),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeacherProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5Solid.sign_out_alt),
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