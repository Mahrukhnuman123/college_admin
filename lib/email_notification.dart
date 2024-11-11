import 'package:flutter/material.dart';
import 'package:untitled2/baseemailnotification.dart';

class StudentEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmailPage(
      containerColor: Color(0xFF1B9BDA), // Student's container color
      titleColor: Color(0xFF1B9BDA), // Student's title color
      buttonColor: Color(0xFF1B9BDA), // Student's button color
      appBarTitle: 'Send Email - Student', // Student's app bar title
    );
  }
}
