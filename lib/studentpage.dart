import 'package:flutter/material.dart';
import 'package:untitled2/add_student.dart';
import 'package:untitled2/attendence_record.dart';
import 'package:untitled2/email_notification.dart';
import 'package:untitled2/events.dart';
import 'package:untitled2/timetable.dart';

import 'courses.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:Color(0xFF1B9BDA),
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
              _buildGridTile(context, 'Add a Student', AddStudentPage(),Icons.person_add),
              _buildGridTile(context, 'Add Attendance', AdminPanel(),Icons.add_box_sharp),
              _buildGridTile(context, 'Timetable', Timetable(),Icons.more_time_sharp),
              _buildGridTile(context, 'Events', EventsPage(),Icons.event),
              _buildGridTile(context, 'EmailNotificaton', EmailNotification(),Icons.email),
              _buildGridTile(context, 'Courses', Courses(),Icons.calendar_month_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, String title, Widget page,IconData icon) {
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
                  icon,
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
