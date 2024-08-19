import 'package:flutter/material.dart';
import 'package:untitled2/teacher_admin/add_attendence.dart';
import 'package:untitled2/teacher_admin/add_teacher.dart';
import 'package:untitled2/teacher_admin/notificationteacher.dart';
import 'package:untitled2/teacher_admin/t_courses.dart';
import 'package:untitled2/teacher_admin/t_email_noti.dart';
import 'package:untitled2/teacher_admin/t_events.dart';
import 'package:untitled2/teacher_admin/teacher_timetable.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF333A56), // Set the background color to blue
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white, // Set the icon color to white
            onPressed: () {
              Navigator.of(context).pop(); // Go back to the previous screen
            },
          ),
          title: const Text(
            'Teacher Dashboard',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(18.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items per row
              crossAxisSpacing: 10.0, // Horizontal space between items
              mainAxisSpacing: 10.0, // Vertical space between items
            ),
            children: [
              _buildGridTile('Add a Teacher', Icons.person_add, AddTeacher()),
              _buildGridTile('Timetable', Icons.event, TeacherTimetable()),
              _buildGridTile('EmailNotification', Icons.event, EmailSenderPage()),
              _buildGridTile('Courses', Icons.calendar_month_outlined, T_Courses(),),
              _buildGridTile('Notification', Icons.calendar_month_outlined, NotificationTeacher(),),
              _buildGridTile('Events', Icons.calendar_month_outlined, T_events(),),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridTile(String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
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
                backgroundColor: const Color(0xFF333A56),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF333A56),
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
}
