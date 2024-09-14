import 'package:flutter/material.dart';
import 'package:my_presence/assets/database/database_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class JustificationForm extends StatefulWidget {
  final int? studentPresenceId;

  const JustificationForm({super.key, required this.studentPresenceId});

  @override
  _JustificationFormState createState() => _JustificationFormState();
}

class _JustificationFormState extends State<JustificationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Plugin de notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Afficher une notification après la soumission
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // ID du canal
      'your_channel_name', // Nom du canal
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Justification soumise',
      'Votre justification a été soumise avec succès.',
      platformChannelSpecifics,
    );
  }

  Future<void> _submitJustification() async {
  if (_formKey.currentState!.validate()) {
    String reason = _reasonController.text;
    String date = _dateController.text;

    // Vérifiez si studentPresenceId est null avant de procéder
    if (widget.studentPresenceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID de présence étudiant non fourni')),
      );
      return;
    }

    try {
      // Créer une instance de DatabaseHelper
      final dbHelper = DatabaseHelper();

      // Appel à la méthode pour insérer la justification
      await dbHelper.insertJustification(
        widget.studentPresenceId!,
        reason,
        date,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Justification ajoutée avec succès !')),
      );

      // Afficher une notification
      await _showNotification();

      // Retour à la page précédente
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout de la justification : $e')),
      );
    }
  }
}

  // Sélectionner une date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soumettre une justification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Raison de l\'absence',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une raison';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _submitJustification,
                child: const Text('Soumettre la justification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}