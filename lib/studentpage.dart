import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:untitled2/add_student.dart';
import 'package:untitled2/attendence_record.dart';
import 'package:untitled2/email_notification.dart';
import 'package:untitled2/events.dart';
import 'package:untitled2/teacher_admin/Notification.dart';
import 'package:untitled2/timetable.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color:
              Colors.white, // Set the color of the arrow (back icon) to white
        ),
        title: Text(
          'Student Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          padding: EdgeInsets.all(16.0),
          children: [
            _buildGridTile(context, 'Add a Student', AddStudentPage()),
            _buildGridTile(context, 'Timetable', Timetable()),
            _buildGridTile(context, 'Events', Event()),
            _buildGridTile(context, 'EmailSendNotificaton', EmailSenderPage()),
            _buildGridTile(context, 'Notificaton', NotificationPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xff1b9bda),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xff1b9bda),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(String title, VoidCallback onPressed) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text(title),
      ),
    );
  }
}
