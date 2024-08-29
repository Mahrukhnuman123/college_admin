import 'package:flutter/material.dart';
import 'package:untitled2/add_student.dart';
import 'package:untitled2/courses_student.dart';
import 'package:untitled2/events.dart';
import 'package:untitled2/teacher_admin/add_teacher.dart';
import 'package:untitled2/teacher_admin/notificationteacher.dart';
import 'package:untitled2/teacher_admin/t_email_noti.dart';
import 'package:untitled2/teacher_admin/t_events.dart';
import 'package:untitled2/teacher_admin/teacher_timetable.dart';
import 'package:untitled2/timetable.dart';
import 'package:untitled2/email_notification.dart';
import 'package:untitled2/teacher_admin/Notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  int _selectedIndex = 0;

  // Pages for the navigation bar
  final List<Widget> _pages = [
    DashboardContent(),
    NotificationTeacher(), // Your existing notification page
    EmailSenderPage(),  // Your existing email notification page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFF333A56).withOpacity(0.9),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color(0xFF333A56).withOpacity(0.9),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white), // Dashboard
          Icon(Icons.notifications, size: 30, color: Colors.white), // Notifications
          Icon(Icons.email, size: 30, color: Colors.white), // Email Notifications
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Container with Curved Edges
        ClipPath(
          clipper: TopCurveClipper(),
          child: Container(
            color: Color(0xFF333A56).withOpacity(0.9),
            width: double.infinity,
            height: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Teacher/Admin/Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        // GridView with Menu Options
        Expanded(
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            padding: EdgeInsets.all(16.0),
            children: [
              _buildGridTile(
                context,
                'Add a Teacher',
                AddTeacher(),
                Icons.person_add, // Icon for adding a teacher
              ),
              _buildGridTile(
                context,
                'Timetable',
                TimetableT(),
                Icons.schedule, // Icon for timetable
              ),
              _buildGridTile(
                context,
                'Courses',
                CoursesStudent (),
                Icons.book, // Icon for courses
              ),
              _buildGridTile(
                context,
                'Events',
                T_events(),
                Icons.event, // Icon for events
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridTile(BuildContext context, String title, Widget page, IconData icon) {
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
                backgroundColor: Color(0xFF333A56),
                child: Icon(
                  icon, // Use the passed icon here
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
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

// Custom Clipper for Curved Edges
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
