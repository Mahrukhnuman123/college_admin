import 'package:flutter/material.dart';
import 'package:untitled2/baseemailnotification.dart';

class TeacherEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmailPage(
      containerColor: Color(0xFF4A5A6A), // Teacher's container color
      titleColor: Color(0xFF4A5A6A), // Teacher's title color
      buttonColor: Color(0xFF4A5A6A), // Teacher's button color
      appBarTitle: 'Send Email - Teacher', // Teacher's app bar title
    );
  }
}
