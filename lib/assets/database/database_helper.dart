import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class DatabaseHelper {
  static var instance;

  // Initialiser la base de données
  static Future<Database> initializeDatabase() async {
    // Obtenir le chemin vers le répertoire de l'application
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.sqlite');

    // Vérifier si la base de données existe
    bool dbExists = await databaseExists(path);

    if (!dbExists) {
      // Si elle n'existe pas, la copier depuis les assets
      ByteData data = await rootBundle.load('assets/database/data.sqlite');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Écrire le fichier copié dans le répertoire local
      await File(path).writeAsBytes(bytes);
    }

    // Ouvrir la base de données
    return await openDatabase(path);
  }

// Méthodes CRUD pour la table `students`

  // Créer un étudiant
  Future<void> insertStudent(
      String name, String email, String password, int classId) async {
    Database db = await initializeDatabase();

    await db.rawInsert(
      'INSERT INTO students (name, email, password, class_id, created_at, updated_at) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
      [name, email, password, classId],
    );
  }

  // Lire les étudiants associés à un coordinateur
Future<List<Map<String, dynamic>>> getStudentsByCoordinator(int coordinatorId) async {
  Database db = await initializeDatabase();

  // Récupérer toutes les classes dont la description contient le coordonateur spécifié
  const queryClasses = '''
    SELECT id, description
    FROM classes
    WHERE description LIKE ?
  ''';

  List<Map<String, dynamic>> classes = await db.rawQuery(queryClasses, ['%Coordinator: $coordinatorId%']);

  // Extraire les IDs des étudiants depuis la colonne description
  List<int> studentIds = [];
  for (var clazz in classes) {
    String description = clazz['description'] as String;
    studentIds.addAll(_parseStudentIds(description));
  }

  // Si aucun étudiant n'est trouvé, renvoyer une liste vide
  if (studentIds.isEmpty) {
    return [];
  }

  // Récupérer les détails des étudiants
  final queryStudents = '''
    SELECT *
    FROM students
    WHERE id IN (${studentIds.join(',')})
  ''';

  return await db.rawQuery(queryStudents);
}

// Fonction pour extraire les IDs des étudiants depuis la description
List<int> _parseStudentIds(String description) {
  final studentIdPattern = RegExp(r'Students: ([\d, ]+)');
  final match = studentIdPattern.firstMatch(description);
  if (match != null) {
    final idsString = match.group(1) ?? '';
    return idsString.split(',').map((id) => int.tryParse(id.trim()) ?? 0).toList();
  }
  return [];
}

// Lire les étudiants associés à un enseignant
Future<List<Map<String, dynamic>>> getStudentsByTeacher(int teacherId) async {
  Database db = await initializeDatabase();

  // Récupérer toutes les classes dont la description contient l'enseignant spécifié
  const queryClasses = '''
    SELECT id
    FROM classes
    WHERE description LIKE ?
  ''';

  List<Map<String, dynamic>> classes = await db.rawQuery(queryClasses, ['%Teacher: $teacherId%']);

  // Extraire les IDs des classes
  List<int> classIds = classes.map((clazz) => clazz['id'] as int).toList();

  // Si aucun ID de classe n'est trouvé, renvoyer une liste vide
  if (classIds.isEmpty) {
    return [];
  }

  // Récupérer les détails des étudiants dont le class_id correspond à un des IDs des classes
  final queryStudents = '''
    SELECT *
    FROM students
    WHERE class_id IN (${classIds.join(',')})
  ''';

  return await db.rawQuery(queryStudents);
}

  // Mettre à jour un étudiant
  Future<void> updateStudent(
      int id, String name, String email, String password, int classId) async {
    Database db = await initializeDatabase();

    await db.rawUpdate(
      'UPDATE students SET name = ?, email = ?, password = ?, class_id = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
      [name, email, password, classId, id],
    );
  }

  // Supprimer un étudiant
  Future<void> deleteStudent(int id) async {
    Database db = await initializeDatabase();

    await db.rawDelete('DELETE FROM students WHERE id = ?', [id]);
  }

// Méthodes CRUD pour la table `parents`

  // Créer un parent
  Future<void> insertParent(
      String name, String email, String password, String student) async {
    Database db = await initializeDatabase();

    await db.rawInsert(
      'INSERT INTO parents (name, email, password, created_at, updated_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
      [name, email, password],
    );
  }

  // Lire tous les parents
  Future<List<Map<String, dynamic>>> getParents() async {
    Database db = await initializeDatabase();

    return await db.rawQuery('SELECT * FROM parents ORDER BY name');
  }

  // Mettre à jour un parent
  Future<void> updateParent(int id, String name, String email, String password,
      String student) async {
    Database db = await initializeDatabase();

    await db.rawUpdate(
      'UPDATE parents SET name = ?, email = ?, password = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
      [name, email, password, id],
    );
  }

  // Supprimer un parent
  Future<void> deleteParent(int id) async {
    Database db = await initializeDatabase();

    await db.rawDelete('DELETE FROM parents WHERE id = ?', [id]);
  }

// Méthodes CRUD pour la table `teachers`

  // Créer un enseignant
  Future<void> insertTeacher(
      String name, String email, String password, String subject) async {
    Database db = await initializeDatabase();

    await db.rawInsert(
      'INSERT INTO teachers (name, email, password, created_at, updated_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
      [name, email, password],
    );
  }

  // Lire tous les enseignants
  Future<List<Map<String, dynamic>>> getTeachers() async {
    Database db = await initializeDatabase();

    return await db.rawQuery('SELECT * FROM teachers ORDER BY name');
  }

  // Mettre à jour un enseignant
  Future<void> updateTeacher(int id, String name, String email, String password,
      String subject) async {
    Database db = await initializeDatabase();

    await db.rawUpdate(
      'UPDATE teachers SET name = ?, email = ?, password = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
      [name, email, password, id],
    );
  }

  // Supprimer un enseignant
  Future<void> deleteTeacher(int id) async {
    Database db = await initializeDatabase();

    await db.rawDelete('DELETE FROM teachers WHERE id = ?', [id]);
  }

// Méthodes CRUD pour la table `coordinators`

  // Créer un coordinateur
  Future<void> insertCoordinator(
      int userId, String email, String hashedPassword, String className) async {
    Database db = await initializeDatabase();

    await db.rawInsert(
      'INSERT INTO coordinators (user_id, created_at, updated_at) VALUES (?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
      [userId],
    );
  }

  // Lire tous les coordinateurs
  Future<List<Map<String, dynamic>>> getCoordinators() async {
    Database db = await initializeDatabase();

    return await db.rawQuery('SELECT * FROM coordinators ORDER BY id');
  }

  // Mettre à jour un coordinateur
  Future<void> updateCoordinator(int id, int userId, String email,
      String hashedPassword, String className) async {
    Database db = await initializeDatabase();

    await db.rawUpdate(
      'UPDATE coordinators SET user_id = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
      [userId, id],
    );
  }

  // Supprimer un coordinateur
  Future<void> deleteCoordinator(int id) async {
    Database db = await initializeDatabase();

    await db.rawDelete('DELETE FROM coordinators WHERE id = ?', [id]);
  }

//emplois du temps

  //create emplois du temps
  Future<void> insertCourseTime(int courseId, int classId, int teacherId,
      String date, String startTime, String endTime) async {
    Database db = await initializeDatabase();

    await db.rawInsert(
      'INSERT INTO course_time (course_id, class_id, teacher_id, date, start_time, end_time, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
      [courseId, classId, teacherId, date, startTime, endTime],
    );
  }

  //read emplois du temps
  Future<List<Map<String, dynamic>>> getCourseTimes() async {
    Database db = await initializeDatabase();

    return await db.rawQuery('SELECT * FROM course_time ORDER BY date');
  }

  //update emplois du temps
  Future<void> updateCourseTime(int id, int courseId, int classId,
      int teacherId, String date, String startTime, String endTime) async {
    Database db = await initializeDatabase();

    await db.rawUpdate(
      'UPDATE course_time SET course_id = ?, class_id = ?, teacher_id = ?, date = ?, start_time = ?, end_time = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
      [courseId, classId, teacherId, date, startTime, endTime, id],
    );
  }

  //justification
  
  //create justification
  Future<void> insertJustification(
    int studentPresenceId, String reason, String date) async {
  Database db = await initializeDatabase();

  // Vérifier si le statut est bien 'absent' pour cet enregistrement dans student_presence
  List<Map<String, dynamic>> result = await db.query(
    'student_presence',
    where: 'id = ? AND status = ?',
    whereArgs: [studentPresenceId, 'absent'],
  );

  if (result.isNotEmpty) {
    // Si l'étudiant est bien absent, on insère la justification
    await db.rawInsert(
      'INSERT INTO justifications (student_presence_id, reason, date, created_at, updated_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
      [studentPresenceId, reason, date],
    );
  } else {
    throw Exception('Justification non permise : l\'étudiant n\'est pas marqué comme absent.');
  }
}


//read justification
  Future<List<Map<String, dynamic>>> getJustifications() async {
    Database db = await initializeDatabase();

    return await db.rawQuery('SELECT * FROM justifications ORDER BY date');
  }

  //create user
  Future<void> insertUser(
      String role, String name, String email, String password,
      {int? classId,
      String? student,
      String? subject,
      String? className}) async {
    switch (role.toLowerCase()) {
      case 'student':
        await insertStudent(name, email, password, classId!);
        break;
      case 'parent':
        await insertParent(name, email, password, student!);
        break;
      case 'teacher':
        await insertTeacher(name, email, password, subject!);
        break;
      case 'coordinator':
        await insertCoordinator(classId!, email, password, className!);
        break;
      default:
        throw Exception('Role non reconnu : $role');
    }
  }

// Méthodes CRUD pour la table `student_presence`

// Créer une présence
  Future<void> insertstudent_presence(
      int studentId, int courseId, String date, String status) async {
    Database db = await initializeDatabase();

    await db.rawInsert(
      'INSERT INTO attendances (student_id, course_id, date, status, created_at, updated_at) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
      [studentId, courseId, date, status],
    );
  }

// Lire toutes les présences
  Future<List<Map<String, dynamic>>> getstudent_presence(DateTime date) async {
    Database db = await initializeDatabase();

    return await db.rawQuery('SELECT * FROM attendances ORDER BY date');
  }

// Mettre à jour une présence
  Future<void> updatestudent_presence(
      int id, int studentId, int courseId, String date, String status) async {
    Database db = await initializeDatabase();

    await db.rawUpdate(
      'UPDATE attendances SET student_id = ?, course_id = ?, date = ?, status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
      [studentId, courseId, date, status, id],
    );
  }

  //connexion
 Future<void> logoutUser(int userId, String role, BuildContext context) async {
    Database db = await initializeDatabase();

    // Mettre à jour le statut de connexion pour l'utilisateur
    await db.rawUpdate(
      'UPDATE user_sessions SET status = ? WHERE user_id = ? AND role = ?',
      ['logged_out', userId, role],
    );

    // Rediriger vers la page de connexion
    Navigator.pushReplacementNamed(context, '/login');
  }

  //taux de presence par etudiant
  Future<Map<int, double>> calculateStudentAttendanceRates() async {
  Database db = await initializeDatabase();

  // Récupérer la liste des étudiants
  List<Map<String, dynamic>> students = await db.rawQuery('SELECT id FROM students');

  // Initialiser un map pour stocker les taux de présence
  Map<int, double> studentAttendanceRates = {};

  for (var student in students) {
    int studentId = student['id'];
    
    // Compter le nombre de fois que l'étudiant est marqué comme présent
    List<Map<String, dynamic>> presenceRecords = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM student_presence WHERE student_id = ? AND status = ?',
      [studentId, 'present']
    );
    int presentCount = Sqflite.firstIntValue(presenceRecords) ?? 0;

    // Compter le nombre total de sessions auxquelles l'étudiant aurait dû assister
    List<Map<String, dynamic>> totalSessions = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM course_time WHERE class_id = (SELECT class_id FROM students WHERE id = ?)',
      [studentId]
    );
    int totalCount = Sqflite.firstIntValue(totalSessions) ?? 0;

    // Calculer le taux de présence
    double attendanceRate = totalCount > 0 ? (presentCount / totalCount) * 100 : 0;

    // Ajouter au map
    studentAttendanceRates[studentId] = attendanceRate;
  }

  return studentAttendanceRates;
}

  //taux de presence par classe
  Future<Map<int, double>> calculateClassAttendanceRates() async {
  Database db = await initializeDatabase();

  // Récupérer la liste des classes
  List<Map<String, dynamic>> classes = await db.rawQuery('SELECT id FROM classes');

  // Initialiser un map pour stocker les taux de présence par classe
  Map<int, double> classAttendanceRates = {};

  for (var clazz in classes) {
    int classId = clazz['id'];

    // Compter le nombre total de présences pour tous les étudiants de la classe
    List<Map<String, dynamic>> presenceRecords = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM student_presence WHERE student_id IN (SELECT id FROM students WHERE class_id = ?) AND status = ?',
      [classId, 'present']
    );
    int presentCount = Sqflite.firstIntValue(presenceRecords) ?? 0;

    // Compter le nombre total de sessions pour la classe
    List<Map<String, dynamic>> totalSessions = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM course_time WHERE class_id = ?',
      [classId]
    );
    int totalCount = Sqflite.firstIntValue(totalSessions) ?? 0;

    // Calculer le taux de présence
    double attendanceRate = totalCount > 0 ? (presentCount / totalCount) * 100 : 0;

    // Ajouter au map
    classAttendanceRates[classId] = attendanceRate;
  }

  return classAttendanceRates;
}

  //taux de presence par semestre
  Future<Map<String, double>> calculateSemesterAttendanceRates(int year) async {
  Database db = await initializeDatabase();
  
  // Définir les dates de début et de fin pour chaque semestre
  List<Map<String, dynamic>> semesters = [
    {'label': 'S1', 'start': '$year-10-01', 'end': '${year + 1}-03-31'},
    {'label': 'S2', 'start': '${year + 1}-04-01', 'end': '${year + 1}-09-30'},
  ];

  // Initialiser un map pour stocker les taux de présence par semestre
  Map<String, double> semesterAttendanceRates = {};

  for (var semester in semesters) {
    String label = semester['label'] as String;
    String start = semester['start'] as String;
    String end = semester['end'] as String;

    // Compter le nombre total de présences pour tous les étudiants dans le semestre
    List<Map<String, dynamic>> presenceRecords = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM student_presence WHERE status = ? AND date BETWEEN ? AND ?',
      ['present', start, end]
    );
    int presentCount = Sqflite.firstIntValue(presenceRecords) ?? 0;

    // Compter le nombre total de sessions dans le semestre
    List<Map<String, dynamic>> totalSessions = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM course_time WHERE date BETWEEN ? AND ?',
      [start, end]
    );
    int totalCount = Sqflite.firstIntValue(totalSessions) ?? 0;

    // Calculer le taux de présence
    double attendanceRate = totalCount > 0 ? (presentCount / totalCount) * 100 : 0;

    // Ajouter au map
    semesterAttendanceRates[label] = attendanceRate;
  }

  return semesterAttendanceRates;
}

}