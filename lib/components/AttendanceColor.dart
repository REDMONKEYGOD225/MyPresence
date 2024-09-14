import 'package:flutter/material.dart';

Color getAttendanceColor(double attendanceRate) {
  if (attendanceRate >= 70) {
    return Colors.green[900]!; // Dark green
  } else if (attendanceRate > 50 && attendanceRate <= 69.9) {
    return Colors.green[400]!; // Light green
  } else if (attendanceRate > 30 && attendanceRate <= 50) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}