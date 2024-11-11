import 'package:flutter/material.dart';
import 'package:untitled2/baseadduser.dart';

class AddTeacherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseAddPage(
      pageTitle: 'Add a Teacher',
      appBarColor: Color(0xFF333A56),
      containerColor: Color(0xFF333A56),
      buttonColor: Color(0xFF333A56),
      roleType: 'Teachers',
    );
  }
}
