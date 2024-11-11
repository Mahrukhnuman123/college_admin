import 'package:flutter/material.dart';
import 'package:untitled2/basenotifications.dart';


class NotificationStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationPageBase(
      collectionName: 'notifications',  // Collection for student notifications
      appBarTitle: 'Send Student Notification',
      appBarColor: Color(0xFF1B9BDA),
      buttonColor: Colors.white,
      buttonTextColor: Colors.blue,
    );
  }
}
