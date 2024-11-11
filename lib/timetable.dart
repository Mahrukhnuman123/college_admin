import 'package:flutter/material.dart';
import 'package:untitled2/basetimetable.dart';

class TimetableStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimetablePage(
      pageTitle: 'Student Timetable',
      appBarColor: Color(0xFF1B9BDA), // Sky Blue
      titleColor: Colors.white,
      collectionName: 'Timetable',
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TimetableStudent(),
  ));
}
