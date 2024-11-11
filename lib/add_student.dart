import 'package:flutter/material.dart';
import 'package:untitled2/baseadduser.dart';


class AddStudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseAddPage(
      pageTitle: 'Add a Student',
      appBarColor: Color(0xFF1B9BDA),
      containerColor: Color(0xFF1B9BDA),
      buttonColor: Color(0xFF1B9BDA),
      roleType: 'Students',
    );
  }
}
