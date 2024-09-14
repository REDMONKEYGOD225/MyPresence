import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PresenceDropdown extends StatefulWidget {
  final String? initialPresence;
  final String? presenceDate;
  final void Function(String) onSave;

  const PresenceDropdown({
    super.key,
    required this.initialPresence,
    required this.presenceDate,
    required this.onSave,
  });

  @override
  _PresenceDropdownState createState() => _PresenceDropdownState();
}

class _PresenceDropdownState extends State<PresenceDropdown> {
  late String _presenceState;

  @override
  void initState() {
    super.initState();
    _presenceState = widget.initialPresence ?? 'Présent';
  }

  @override
  Widget build(BuildContext context) {
    DateTime? presenceDate = widget.presenceDate != null
        ? DateFormat('yyyy-MM-dd').parse(widget.presenceDate!)
        : null;

    bool isWithinTwoWeeks = presenceDate == null ||
        DateTime.now().difference(presenceDate).inDays <= 14;

    DateTime currentDate = DateTime.now();
    bool isFridayEveningOrLater = currentDate.weekday == DateTime.friday &&
        currentDate.hour >= 18;

    return Row(
      children: [
        DropdownButton<String>(
          value: _presenceState,
          onChanged: (String? newValue) {
            setState(() {
              _presenceState = newValue!;
            });
          },
          items: <String>['Présent', 'Absent', 'En retard']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () {
            if (isWithinTwoWeeks && !isFridayEveningOrLater) {
              widget.onSave(_presenceState);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Modification de l\'état de présence impossible après deux semaines ou après vendredi soir.'),
                ),
              );
            }
          },
          child: Text(isWithinTwoWeeks && presenceDate != null ? 'Modifier' : 'Enregistrer'),
        ),
      ],
    );
  }
}
