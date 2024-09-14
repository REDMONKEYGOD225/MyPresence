import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CoordinatorAttendanceChart extends StatelessWidget {
  final List<StudentAttendance> studentAttendances;

  const CoordinatorAttendanceChart({super.key, required this.studentAttendances});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coordinator Attendance Chart")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barGroups: studentAttendances.map((attendance) {
              return BarChartGroupData(
                x: attendance.studentId,
                barRods: [
                  BarChartRodData(
                    toY: attendance.attendanceRate,
                    color: getAttendanceColor(attendance.attendanceRate),
                    width: 20,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

Color getAttendanceColor(double attendanceRate) {
  if (attendanceRate >= 70) {
    return Colors.green[900]!;
  } else if (attendanceRate > 50 && attendanceRate <= 69.9) {
    return Colors.green[400]!;
  } else if (attendanceRate > 30 && attendanceRate <= 50) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

class StudentAttendance {
  final int studentId;
  final String studentName;
  final double attendanceRate;

  StudentAttendance({
    required this.studentId,
    required this.studentName,
    required this.attendanceRate,
  });
}