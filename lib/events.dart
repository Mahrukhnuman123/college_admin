import 'package:flutter/material.dart';
import 'package:untitled2/baseeventpage.dart';
import 'baseeventpage.dart'; // Ensure that this is the correct import path for your BaseEventPage class

class StudentEventPage extends StatelessWidget {
  const StudentEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseEventPage(
      collectionName: 't_events', // Student events collection
      appBarColor: Color(0xff1b9bda), // App bar color for student page
    );
  }
}
