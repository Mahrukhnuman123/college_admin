import 'package:flutter/material.dart';
import 'package:untitled2/baseeventpage.dart';
// Make sure to import your BaseEventPage file correctly

class TeacherEventPage extends StatelessWidget {
  const TeacherEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseEventPage(
      collectionName: 't_events', // Teacher events collection
      appBarColor: const Color(0xFF4A5A6A), // App bar color for teacher page
    );
  }
}
