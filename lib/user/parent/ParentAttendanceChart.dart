import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_presence/components/AttendanceColor.dart';

class ParentAttendanceChart extends StatelessWidget {
  final List<StudentAttendance> studentAttendances;

  const ParentAttendanceChart({super.key, required this.studentAttendances});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Attendance Chart")),
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