import 'package:flutter/material.dart';
import 'package:untitled2/basetimetable.dart';

class TimetableTeacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimetablePage(
      pageTitle: 'Teacher Timetable',
      appBarColor: Color(0xFF333A56), // Darker Blue
      titleColor: Colors.white,
      collectionName: 'TeacherTimetable',
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TimetableTeacher(),
  ));
}
