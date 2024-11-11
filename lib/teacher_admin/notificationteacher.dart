import 'package:flutter/material.dart';
import 'package:untitled2/basenotifications.dart';

class NotificationTeacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationPageBase(
      collectionName: 'T_notifications',  // Collection for teacher notifications
      appBarTitle: 'Send Teacher Notification',
      appBarColor: Color(0xFF333A56),
      buttonColor: Colors.white,
      buttonTextColor: Color(0xFF333A56),
    );
  }
}
